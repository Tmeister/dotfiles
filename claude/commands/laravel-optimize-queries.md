# Laravel Query Optimization

Detect and fix N+1 query problems, optimize Eloquent queries, suggest database indexes, and implement efficient data retrieval patterns following Laravel best practices.

## Instructions

Optimize Laravel database queries and performance: **$ARGUMENTS**

**Flags:**
- `--n-plus-one`: Focus on detecting and fixing N+1 query problems
- `--indexes`: Analyze and suggest database indexes
- `--chunking`: Implement query chunking for large datasets
- `--eager-loading`: Optimize eager loading strategies
- `--slow-queries`: Identify and optimize slow queries

1. **Query Performance Analysis**
   ```markdown
   ## Database Query Assessment
   
   ### Performance Metrics Collection
   - **Query Count**: Identify endpoints with excessive query counts
   - **Execution Time**: Find queries taking >100ms
   - **Memory Usage**: Detect memory-intensive operations
   - **N+1 Problems**: Locate missing eager loading opportunities
   - **Missing Indexes**: Identify unindexed WHERE/ORDER BY clauses
   
   ### Query Monitoring Setup
   ```php
   // In AppServiceProvider boot() method
   public function boot(): void
   {
       if (app()->environment('local')) {
           DB::listen(function ($query) {
               if ($query->time > 100) {
                   Log::warning('Slow query detected', [
                       'sql' => $query->sql,
                       'time' => $query->time,
                       'bindings' => $query->bindings,
                   ]);
               }
           });
       }
   }
   ```
   ```

2. **N+1 Query Problem Detection and Resolution**
   ```markdown
   ## N+1 Query Elimination
   
   ### Identifying N+1 Problems
   #### Before: N+1 Query Problem
   ```php
   // This will execute 1 + N queries (1 for posts, N for each author)
   public function index()
   {
       $posts = Post::all(); // 1 query
       
       foreach ($posts as $post) {
           echo $post->author->name; // N queries (one per post)
       }
   }
   ```
   
   #### After: Eager Loading Solution
   ```php
   // This will execute only 2 queries total
   public function index()
   {
       $posts = Post::with('author')->get(); // 2 queries total
       
       foreach ($posts as $post) {
           echo $post->author->name; // No additional queries
       }
   }
   ```
   
   ### Advanced Eager Loading Patterns
   #### Nested Relationships
   ```php
   // Load posts with authors and their profiles
   $posts = Post::with(['author.profile', 'comments.user'])->get();
   
   // Load specific columns only
   $posts = Post::with(['author:id,name,email', 'tags:name'])->get();
   
   // Conditional eager loading
   $posts = Post::with(['comments' => function ($query) {
       $query->where('approved', true)->latest();
   }])->get();
   ```
   
   #### Lazy Eager Loading
   ```php
   $posts = Post::all();
   
   // Load author relationship when needed
   if ($includeAuthor) {
       $posts->load('author');
   }
   
   // Load multiple relationships conditionally
   $posts->loadMissing(['author', 'tags']);
   ```
   ```

3. **Database Index Optimization**
   ```markdown
   ## Index Strategy Implementation
   
   ### Index Analysis and Recommendations
   #### Common Index Patterns
   ```php
   // Migration with proper indexes
   Schema::create('orders', function (Blueprint $table) {
       $table->id();
       $table->foreignId('user_id')->constrained();
       $table->string('status');
       $table->decimal('total', 10, 2);
       $table->timestamp('created_at');
       $table->timestamp('updated_at');
       
       // Single column indexes
       $table->index('status');
       $table->index('created_at');
       
       // Composite indexes for common query patterns
       $table->index(['user_id', 'status']);
       $table->index(['status', 'created_at']);
       $table->index(['user_id', 'created_at']);
   });
   ```
   
   #### Query-Specific Index Analysis
   ```php
   // Analyze this query pattern
   $orders = Order::where('user_id', $userId)
                  ->where('status', 'pending')
                  ->orderBy('created_at', 'desc')
                  ->get();
   
   // Requires composite index: (user_id, status, created_at)
   $table->index(['user_id', 'status', 'created_at']);
   ```
   
   ### Index Monitoring
   ```sql
   -- MySQL: Check index usage
   SHOW INDEX FROM orders;
   
   -- Analyze query execution plan
   EXPLAIN SELECT * FROM orders 
   WHERE user_id = 1 AND status = 'pending' 
   ORDER BY created_at DESC;
   ```
   ```

4. **Query Chunking for Large Datasets**
   ```markdown
   ## Large Dataset Processing
   
   ### Chunk Implementation Patterns
   #### Basic Chunking
   ```php
   // Process large datasets in chunks to avoid memory issues
   User::chunk(1000, function ($users) {
       foreach ($users as $user) {
           // Process each user
           $this->processUser($user);
       }
   });
   
   // Chunk with specific columns
   User::select(['id', 'email', 'name'])
       ->chunk(1000, function ($users) {
           $this->sendNewsletterToUsers($users);
       });
   ```
   
   #### Cursor-Based Pagination
   ```php
   // For very large datasets, use cursor pagination
   foreach (User::lazy() as $user) {
       // Process one user at a time without loading all into memory
       $this->processUser($user);
   }
   
   // Lazy with constraints
   foreach (User::where('active', true)->lazy(500) as $user) {
       $this->processActiveUser($user);
   }
   ```
   
   #### Batch Processing
   ```php
   // Process records in batches with proper error handling
   DB::transaction(function () {
       User::whereNull('processed_at')
           ->chunkById(1000, function ($users) {
               foreach ($users as $user) {
                   try {
                       $this->processUser($user);
                       $user->update(['processed_at' => now()]);
                   } catch (Exception $e) {
                       Log::error('User processing failed', [
                           'user_id' => $user->id,
                           'error' => $e->getMessage(),
                       ]);
                   }
               }
           });
   });
   ```
   ```

5. **Eloquent Query Optimization Techniques**
   ```markdown
   ## Advanced Query Optimization
   
   ### Select Specific Columns
   #### Avoid SELECT * Queries
   ```php
   // Bad: Loads all columns
   $users = User::all();
   
   // Good: Load only needed columns
   $users = User::select(['id', 'name', 'email'])->get();
   
   // With relationships
   $posts = Post::select(['id', 'title', 'user_id'])
                ->with(['author:id,name'])
                ->get();
   ```
   
   ### Query Optimization Patterns
   #### Use EXISTS Instead of COUNT
   ```php
   // Bad: Counts all records
   $hasOrders = Order::where('user_id', $userId)->count() > 0;
   
   // Good: Stops at first match
   $hasOrders = Order::where('user_id', $userId)->exists();
   ```
   
   #### Optimize WHERE Clauses
   ```php
   // Use database functions for date comparisons
   $recentOrders = Order::whereDate('created_at', today())->get();
   
   // Use proper indexes for LIKE queries
   $users = User::where('email', 'like', 'john%')->get(); // Can use index
   // Avoid: User::where('email', 'like', '%john%')->get(); // Cannot use index
   ```
   
   #### Subquery Optimization
   ```php
   // Use subqueries for complex conditions
   $usersWithRecentOrders = User::whereHas('orders', function ($query) {
       $query->where('created_at', '>=', now()->subDays(30));
   })->get();
   
   // Alternative with join for better performance
   $usersWithRecentOrders = User::join('orders', 'users.id', '=', 'orders.user_id')
       ->where('orders.created_at', '>=', now()->subDays(30))
       ->distinct()
       ->select('users.*')
       ->get();
   ```
   ```

6. **Caching Strategies for Query Optimization**
   ```markdown
   ## Query Result Caching
   
   ### Model Caching Implementation
   #### Basic Query Caching
   ```php
   // Cache expensive queries
   $popularPosts = Cache::remember('popular_posts', 3600, function () {
       return Post::with(['author', 'tags'])
                  ->where('views', '>', 1000)
                  ->orderBy('views', 'desc')
                  ->limit(10)
                  ->get();
   });
   
   // Cache with tags for better invalidation
   $userPosts = Cache::tags(['posts', "user_{$userId}"])
       ->remember("user_posts_{$userId}", 1800, function () use ($userId) {
           return Post::where('user_id', $userId)
                     ->with('tags')
                     ->orderBy('created_at', 'desc')
                     ->get();
       });
   ```
   
   #### Model-Level Caching
   ```php
   // In User model
   public function getCachedOrdersAttribute()
   {
       return Cache::remember(
           "user_orders_{$this->id}",
           3600,
           fn() => $this->orders()->with('items')->get()
       );
   }
   
   // Cache invalidation on model events
   protected static function booted()
   {
       static::saved(function ($user) {
           Cache::forget("user_orders_{$user->id}");
       });
   }
   ```
   ```

7. **Database Connection and Query Optimization**
   ```markdown
   ## Connection and Configuration Optimization
   
   ### Database Configuration
   #### Connection Pool Optimization
   ```php
   // config/database.php
   'mysql' => [
       'driver' => 'mysql',
       'host' => env('DB_HOST', '127.0.0.1'),
       'port' => env('DB_PORT', '3306'),
       'database' => env('DB_DATABASE', 'forge'),
       'username' => env('DB_USERNAME', 'forge'),
       'password' => env('DB_PASSWORD', ''),
       'charset' => 'utf8mb4',
       'collation' => 'utf8mb4_unicode_ci',
       'prefix' => '',
       'prefix_indexes' => true,
       'strict' => true,
       'engine' => null,
       'options' => extension_loaded('pdo_mysql') ? array_filter([
           PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
           PDO::ATTR_PERSISTENT => true, // Connection pooling
           PDO::ATTR_TIMEOUT => 30,
       ]) : [],
   ],
   ```
   
   #### Read/Write Connections
   ```php
   'mysql' => [
       'read' => [
           'host' => [
               '192.168.1.1', // Read replica 1
               '192.168.1.2', // Read replica 2
           ],
       ],
       'write' => [
           'host' => [
               '192.168.1.3', // Master database
           ],
       ],
       'sticky' => true, // Ensure read-after-write consistency
       // ... other configuration
   ],
   ```
   ```

8. **Query Performance Monitoring and Debugging**
   ```markdown
   ## Performance Monitoring Setup
   
   ### Query Debugging Tools
   #### Laravel Telescope Integration
   ```php
   // Monitor all database queries
   public function boot(): void
   {
       if (app()->environment('local')) {
           DB::listen(function ($query) {
               // Log slow queries
               if ($query->time > 100) {
                   Log::channel('slow_queries')->warning('Slow query', [
                       'sql' => $query->sql,
                       'bindings' => $query->bindings,
                       'time' => $query->time . 'ms',
                       'trace' => debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS, 5),
                   ]);
               }
           });
       }
   }
   ```
   
   #### Custom Query Analyzer
   ```php
   class QueryAnalyzer
   {
       public static function analyzeEndpoint(string $endpoint): array
       {
           $queries = [];
           
           DB::listen(function ($query) use (&$queries) {
               $queries[] = [
                   'sql' => $query->sql,
                   'bindings' => $query->bindings,
                   'time' => $query->time,
               ];
           });
   
           // Make request to endpoint
           $response = $this->makeRequest($endpoint);
   
           return [
               'query_count' => count($queries),
               'total_time' => array_sum(array_column($queries, 'time')),
               'queries' => $queries,
               'n_plus_one_detected' => $this->detectNPlusOne($queries),
           ];
       }
   
       private static function detectNPlusOne(array $queries): bool
       {
           $patterns = [];
           foreach ($queries as $query) {
               $pattern = preg_replace('/\d+/', '?', $query['sql']);
               $patterns[] = $pattern;
           }
   
           return count($patterns) !== count(array_unique($patterns));
       }
   }
   ```
   ```

## Usage Examples

```bash
# Analyze N+1 problems in specific controller
/laravel-optimize-queries --n-plus-one app/Http/Controllers/PostController.php

# Suggest indexes for all models
/laravel-optimize-queries --indexes app/Models/

# Implement chunking for large dataset operations
/laravel-optimize-queries --chunking app/Console/Commands/ProcessUsers.php

# Optimize eager loading strategies
/laravel-optimize-queries --eager-loading app/Http/Controllers/Api/

# Identify slow queries across application
/laravel-optimize-queries --slow-queries
```

**Query Optimization Quality Standards:**
- No N+1 query problems in production code
- Database queries should complete in <100ms
- Use appropriate indexes for all WHERE and ORDER BY clauses
- Implement chunking for operations on >1000 records
- Cache expensive queries with proper invalidation
- Monitor query performance in production
- Use eager loading for all relationship access