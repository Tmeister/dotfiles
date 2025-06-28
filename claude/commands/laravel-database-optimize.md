# Laravel Database Optimization

Analyze database schema for optimization opportunities, suggest missing indexes, review migration files, implement database seeding improvements, and optimize MySQL performance.

## Instructions

Optimize Laravel database performance and structure: **$ARGUMENTS**

**Flags:**
- `--indexes`: Analyze and suggest database indexes
- `--migrations`: Review and optimize migration files
- `--schema`: Analyze database schema design
- `--queries`: Optimize database queries and performance
- `--mysql-config`: MySQL-specific configuration optimization

1. **Database Performance Analysis**
   ```markdown
   ## Database Performance Assessment
   
   ### Performance Metrics Collection
   - **Query Performance**: Identify slow queries (>100ms)
   - **Index Usage**: Analyze index effectiveness and coverage
   - **Schema Design**: Review table structure and relationships
   - **Connection Efficiency**: Assess connection pooling and management
   - **Storage Optimization**: Evaluate data types and storage efficiency
   
   ### MySQL Performance Monitoring
   ```sql
   -- Enable slow query log
   SET GLOBAL slow_query_log = 'ON';
   SET GLOBAL long_query_time = 0.1; -- Log queries > 100ms
   
   -- Analyze index usage
   SELECT 
       table_schema,
       table_name,
       non_unique,
       index_name,
       column_name,
       cardinality
   FROM information_schema.statistics
   WHERE table_schema = 'your_database_name'
   ORDER BY table_name, index_name;
   
   -- Find unused indexes
   SELECT 
       object_schema,
       object_name,
       index_name
   FROM performance_schema.table_io_waits_summary_by_index_usage
   WHERE index_name IS NOT NULL
   AND count_star = 0
   AND object_schema = 'your_database_name';
   ```
   ```

2. **Index Optimization Strategy**
   ```markdown
   ## Database Index Analysis and Implementation
   
   ### Index Analysis Framework
   #### Query Pattern Analysis
   ```php
   <?php
   
   namespace App\Console\Commands;
   
   use Illuminate\Console\Command;
   use Illuminate\Support\Facades\DB;
   
   class AnalyzeDatabaseIndexes extends Command
   {
       protected $signature = 'db:analyze-indexes';
       protected $description = 'Analyze database for missing indexes';
   
       public function handle(): void
       {
           $this->info('Analyzing database indexes...');
           
           // Common query patterns that need indexes
           $queryPatterns = [
               'users' => [
                   ['email'], // Login queries
                   ['email_verified_at'], // Verification status
                   ['created_at'], // Recent users
                   ['active', 'created_at'], // Active users by date
               ],
               'posts' => [
                   ['user_id'], // User's posts
                   ['published_at'], // Published posts
                   ['user_id', 'published_at'], // User's published posts
                   ['category_id', 'published_at'], // Category posts
                   ['featured', 'published_at'], // Featured posts
               ],
               'orders' => [
                   ['user_id'], // Customer orders
                   ['status'], // Order status queries
                   ['user_id', 'status'], // Customer order status
                   ['created_at'], // Recent orders
                   ['status', 'created_at'], // Status with date
               ],
           ];
   
           foreach ($queryPatterns as $table => $indexes) {
               $this->analyzeTableIndexes($table, $indexes);
           }
       }
   
       private function analyzeTableIndexes(string $table, array $requiredIndexes): void
       {
           $existingIndexes = $this->getExistingIndexes($table);
           
           foreach ($requiredIndexes as $indexColumns) {
               if (!$this->hasIndex($existingIndexes, $indexColumns)) {
                   $this->warn("Missing index on {$table}: " . implode(', ', $indexColumns));
                   $this->suggestIndexMigration($table, $indexColumns);
               }
           }
       }
   
       private function suggestIndexMigration(string $table, array $columns): void
       {
           $indexName = $table . '_' . implode('_', $columns) . '_index';
           $columnsStr = "'" . implode("', '", $columns) . "'";
           
           $this->line("Suggested migration:");
           $this->line("\$table->index([{$columnsStr}], '{$indexName}');");
           $this->line('');
       }
   }
   ```
   
   ### Optimal Index Migration Patterns
   ```php
   <?php
   
   use Illuminate\Database\Migrations\Migration;
   use Illuminate\Database\Schema\Blueprint;
   use Illuminate\Support\Facades\Schema;
   
   return new class extends Migration
   {
       public function up(): void
       {
           Schema::table('orders', function (Blueprint $table) {
               // Single column indexes
               $table->index('status', 'orders_status_index');
               $table->index('created_at', 'orders_created_at_index');
               
               // Composite indexes (order matters!)
               $table->index(['user_id', 'status'], 'orders_user_status_index');
               $table->index(['status', 'created_at'], 'orders_status_date_index');
               $table->index(['user_id', 'created_at'], 'orders_user_date_index');
               
               // Partial indexes for specific conditions
               $table->index(['user_id'], 'orders_active_user_index')
                     ->where('status', 'active');
               
               // Covering indexes (include additional columns)
               $table->index(['category_id', 'published_at'], 'posts_category_published_index')
                     ->include(['title', 'slug']);
           });
       }
   
       public function down(): void
       {
           Schema::table('orders', function (Blueprint $table) {
               $table->dropIndex('orders_status_index');
               $table->dropIndex('orders_created_at_index');
               $table->dropIndex('orders_user_status_index');
               $table->dropIndex('orders_status_date_index');
               $table->dropIndex('orders_user_date_index');
               $table->dropIndex('orders_active_user_index');
           });
       }
   };
   ```
   ```

3. **Schema Design Optimization**
   ```markdown
   ## Database Schema Enhancement
   
   ### Optimal Data Types and Structure
   #### Efficient Column Design
   ```php
   <?php
   
   use Illuminate\Database\Migrations\Migration;
   use Illuminate\Database\Schema\Blueprint;
   use Illuminate\Support\Facades\Schema;
   
   return new class extends Migration
   {
       public function up(): void
       {
           Schema::create('optimized_users', function (Blueprint $table) {
               // Primary key
               $table->id(); // BIGINT UNSIGNED AUTO_INCREMENT
               
               // String fields with appropriate lengths
               $table->string('name', 100); // Not 255 if not needed
               $table->string('email', 150)->unique();
               $table->string('phone', 20)->nullable();
               
               // Use specific types for better performance
               $table->enum('status', ['active', 'inactive', 'suspended'])
                     ->default('active');
               $table->tinyInteger('role_id')->unsigned(); // vs INT
               $table->boolean('email_verified')->default(false);
               
               // Timestamps and dates
               $table->timestamp('email_verified_at')->nullable();
               $table->timestamp('last_login_at')->nullable();
               $table->date('date_of_birth')->nullable(); // DATE vs DATETIME
               
               // JSON for flexible data
               $table->json('preferences')->nullable();
               $table->json('metadata')->nullable();
               
               // Financial data with proper precision
               $table->decimal('account_balance', 10, 2)->default(0);
               
               // Standard timestamps
               $table->timestamps();
               
               // Indexes for common queries
               $table->index('email');
               $table->index('status');
               $table->index(['status', 'created_at']);
               $table->index('last_login_at');
           });
       }
   };
   ```
   
   ### Relationship Optimization
   ```php
   // Optimized foreign key constraints
   Schema::create('orders', function (Blueprint $table) {
       $table->id();
       
       // Foreign keys with proper constraints
       $table->foreignId('user_id')
             ->constrained()
             ->onUpdate('cascade')
             ->onDelete('cascade');
             
       $table->foreignId('shipping_address_id')
             ->nullable()
             ->constrained('addresses')
             ->onDelete('set null');
       
       // Enum for better performance than string
       $table->enum('status', [
           'pending', 'processing', 'shipped', 
           'delivered', 'cancelled', 'refunded'
       ])->default('pending');
       
       // Optimized decimal for money
       $table->decimal('total', 10, 2);
       $table->decimal('tax_amount', 8, 2)->default(0);
       $table->decimal('shipping_cost', 8, 2)->default(0);
       
       // Currency code
       $table->char('currency', 3)->default('USD');
       
       // Order number with specific length
       $table->string('order_number', 20)->unique();
       
       $table->timestamps();
       
       // Performance indexes
       $table->index(['user_id', 'status']);
       $table->index(['status', 'created_at']);
       $table->index('order_number');
   });
   ```
   ```

4. **Query Optimization Patterns**
   ```markdown
   ## Database Query Performance
   
   ### Query Optimization Service
   #### Query Analysis and Optimization
   ```php
   <?php
   
   namespace App\Services\Database;
   
   use Illuminate\Support\Facades\DB;
   use Illuminate\Support\Collection;
   
   class QueryOptimizationService
   {
       public function analyzeSlowQueries(): Collection
       {
           // Get slow queries from MySQL slow query log
           return DB::select("
               SELECT 
                   sql_text,
                   exec_count,
                   avg_timer_wait/1000000000 as avg_time_seconds,
                   max_timer_wait/1000000000 as max_time_seconds,
                   sum_timer_wait/1000000000 as total_time_seconds
               FROM performance_schema.events_statements_summary_by_digest 
               WHERE avg_timer_wait > 100000000 -- > 0.1 seconds
               ORDER BY avg_timer_wait DESC 
               LIMIT 20
           ");
       }
   
       public function explainQuery(string $sql, array $bindings = []): array
       {
           $explained = DB::select("EXPLAIN FORMAT=JSON " . $sql, $bindings);
           return json_decode($explained[0]->EXPLAIN, true);
       }
   
       public function suggestIndexes(string $table, array $whereColumns, array $orderColumns = []): string
       {
           $indexColumns = array_merge($whereColumns, $orderColumns);
           $indexName = $table . '_' . implode('_', $indexColumns) . '_index';
           
           return "ALTER TABLE {$table} ADD INDEX {$indexName} (" . 
                  implode(', ', $indexColumns) . ");";
       }
   
       public function analyzeTableStats(string $table): array
       {
           $stats = DB::select("
               SELECT 
                   table_rows,
                   data_length,
                   index_length,
                   data_free,
                   avg_row_length
               FROM information_schema.tables 
               WHERE table_schema = DATABASE() 
               AND table_name = ?
           ", [$table]);
   
           return [
               'rows' => $stats[0]->table_rows,
               'data_size_mb' => round($stats[0]->data_length / 1024 / 1024, 2),
               'index_size_mb' => round($stats[0]->index_length / 1024 / 1024, 2),
               'free_space_mb' => round($stats[0]->data_free / 1024 / 1024, 2),
               'avg_row_length' => $stats[0]->avg_row_length,
           ];
       }
   }
   ```
   
   ### Connection Pool Optimization
   ```php
   // config/database.php - Optimized MySQL configuration
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
       'engine' => 'InnoDB',
       'options' => extension_loaded('pdo_mysql') ? array_filter([
           PDO::MYSQL_ATTR_SSL_CA => env('MYSQL_ATTR_SSL_CA'),
           PDO::ATTR_PERSISTENT => true, // Connection pooling
           PDO::ATTR_TIMEOUT => 30,
           PDO::ATTR_EMULATE_PREPARES => false,
           PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true,
       ]) : [],
       
       // Read/Write splitting
       'read' => [
           'host' => [
               env('DB_READ_HOST_1', '127.0.0.1'),
               env('DB_READ_HOST_2', '127.0.0.1'),
           ],
       ],
       'write' => [
           'host' => [
               env('DB_WRITE_HOST', '127.0.0.1'),
           ],
       ],
       'sticky' => true,
   ],
   ```
   ```

5. **Migration Best Practices**
   ```markdown
   ## Migration Optimization and Safety
   
   ### Safe Migration Patterns
   #### Zero-Downtime Migration Strategy
   ```php
   <?php
   
   use Illuminate\Database\Migrations\Migration;
   use Illuminate\Database\Schema\Blueprint;
   use Illuminate\Support\Facades\Schema;
   
   return new class extends Migration
   {
       public function up(): void
       {
           // Step 1: Add new column (nullable first)
           Schema::table('users', function (Blueprint $table) {
               $table->string('new_field')->nullable()->after('existing_field');
           });
           
           // Step 2: Populate data (separate migration)
           // Step 3: Make non-nullable (separate migration)
       }
   
       public function down(): void
       {
           Schema::table('users', function (Blueprint $table) {
               $table->dropColumn('new_field');
           });
       }
   };
   
   // Large table migration with chunking
   class PopulateNewFieldMigration extends Migration
   {
       public function up(): void
       {
           // Process in chunks to avoid memory issues
           User::whereNull('new_field')
               ->chunkById(1000, function ($users) {
                   foreach ($users as $user) {
                       $user->update([
                           'new_field' => $this->calculateNewField($user)
                       ]);
                   }
               });
       }
   
       private function calculateNewField(User $user): string
       {
           // Complex calculation logic
           return "calculated_value_for_{$user->id}";
       }
   }
   ```
   
   ### Index Creation Strategies
   ```php
   // Online index creation for large tables
   return new class extends Migration
   {
       public function up(): void
       {
           // For large tables, create indexes online
           DB::statement('CREATE INDEX CONCURRENTLY orders_user_status_index ON orders(user_id, status)');
       }
   
       public function down(): void
       {
           DB::statement('DROP INDEX CONCURRENTLY orders_user_status_index');
       }
   };
   
   // Conditional index creation
   return new class extends Migration
   {
       public function up(): void
       {
           Schema::table('posts', function (Blueprint $table) {
               // Only create if not exists
               if (!$this->hasIndex('posts', 'posts_category_published_index')) {
                   $table->index(['category_id', 'published_at'], 'posts_category_published_index');
               }
           });
       }
   
       private function hasIndex(string $table, string $indexName): bool
       {
           $indexes = DB::select("SHOW INDEX FROM {$table} WHERE Key_name = ?", [$indexName]);
           return count($indexes) > 0;
       }
   };
   ```
   ```

6. **Database Seeding Optimization**
   ```markdown
   ## Efficient Database Seeding
   
   ### Optimized Seeder Implementation
   #### Bulk Insert Patterns
   ```php
   <?php
   
   namespace Database\Seeders;
   
   use App\Models\User;
   use App\Models\Post;
   use Illuminate\Database\Seeder;
   use Illuminate\Support\Facades\DB;
   
   class OptimizedDatabaseSeeder extends Seeder
   {
       public function run(): void
       {
           // Disable foreign key checks for faster seeding
           DB::statement('SET FOREIGN_KEY_CHECKS=0;');
           
           // Disable query logging
           DB::disableQueryLog();
           
           // Use transactions for consistency
           DB::transaction(function () {
               $this->seedUsers();
               $this->seedPosts();
           });
           
           // Re-enable foreign key checks
           DB::statement('SET FOREIGN_KEY_CHECKS=1;');
       }
   
       private function seedUsers(): void
       {
           // Bulk insert instead of individual creates
           $users = [];
           for ($i = 0; $i < 10000; $i++) {
               $users[] = [
                   'name' => fake()->name(),
                   'email' => fake()->unique()->safeEmail(),
                   'password' => bcrypt('password'),
                   'email_verified_at' => now(),
                   'created_at' => now(),
                   'updated_at' => now(),
               ];
           }
           
           // Insert in chunks to avoid memory issues
           collect($users)->chunk(1000)->each(function ($chunk) {
               User::insert($chunk->toArray());
           });
       }
   
       private function seedPosts(): void
       {
           $userIds = User::pluck('id')->toArray();
           
           // Generate posts data
           $posts = [];
           for ($i = 0; $i < 50000; $i++) {
               $posts[] = [
                   'user_id' => fake()->randomElement($userIds),
                   'title' => fake()->sentence(),
                   'content' => fake()->paragraphs(3, true),
                   'published_at' => fake()->optional(0.8)->dateTimeBetween('-1 year'),
                   'created_at' => now(),
                   'updated_at' => now(),
               ];
           }
           
           // Bulk insert posts
           collect($posts)->chunk(2000)->each(function ($chunk) {
               Post::insert($chunk->toArray());
           });
       }
   }
   ```
   
   ### Factory Optimization
   ```php
   <?php
   
   namespace Database\Factories;
   
   use App\Models\User;
   use Illuminate\Database\Eloquent\Factories\Factory;
   use Illuminate\Support\Facades\Hash;
   
   class UserFactory extends Factory
   {
       protected $model = User::class;
       
       // Cache expensive operations
       private static ?string $hashedPassword = null;
   
       public function definition(): array
       {
           // Cache password hashing for performance
           if (self::$hashedPassword === null) {
               self::$hashedPassword = Hash::make('password');
           }
   
           return [
               'name' => $this->faker->name(),
               'email' => $this->faker->unique()->safeEmail(),
               'email_verified_at' => now(),
               'password' => self::$hashedPassword,
               'remember_token' => \Str::random(10),
           ];
       }
   
       public function unverified(): static
       {
           return $this->state(fn (array $attributes) => [
               'email_verified_at' => null,
           ]);
       }
   
       public function admin(): static
       {
           return $this->state(fn (array $attributes) => [
               'role' => 'admin',
           ]);
       }
   }
   ```
   ```

7. **MySQL Configuration Optimization**
   ```markdown
   ## MySQL Server Optimization
   
   ### MySQL Configuration Tuning
   #### Performance Configuration (my.cnf)
   ```ini
   [mysqld]
   # Basic Settings
   default-storage-engine = InnoDB
   sql-mode = "STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
   
   # Connection Settings
   max_connections = 200
   max_connect_errors = 1000000
   max_allowed_packet = 64M
   
   # InnoDB Settings
   innodb_buffer_pool_size = 2G  # 70-80% of available RAM
   innodb_log_file_size = 256M
   innodb_log_buffer_size = 64M
   innodb_flush_log_at_trx_commit = 2  # Better performance, slight risk
   innodb_flush_method = O_DIRECT
   innodb_file_per_table = 1
   
   # Query Cache (deprecated in MySQL 8.0)
   query_cache_type = 0
   query_cache_size = 0
   
   # Logging
   slow_query_log = 1
   slow_query_log_file = /var/log/mysql/slow.log
   long_query_time = 0.1
   log_queries_not_using_indexes = 1
   
   # Temporary Tables
   tmp_table_size = 64M
   max_heap_table_size = 64M
   
   # Thread Settings
   thread_cache_size = 50
   thread_stack = 256K
   
   # Buffer Settings
   key_buffer_size = 32M
   read_buffer_size = 2M
   read_rnd_buffer_size = 16M
   sort_buffer_size = 8M
   join_buffer_size = 8M
   ```
   
   ### Database Monitoring Queries
   ```sql
   -- Check InnoDB buffer pool efficiency
   SELECT 
       ROUND((1 - (Innodb_buffer_pool_reads / Innodb_buffer_pool_read_requests)) * 100, 2) 
       AS buffer_pool_hit_rate;
   
   -- Find tables without primary keys
   SELECT 
       table_schema,
       table_name
   FROM information_schema.tables t
   LEFT JOIN information_schema.table_constraints tc
       ON t.table_schema = tc.table_schema
       AND t.table_name = tc.table_name
       AND tc.constraint_type = 'PRIMARY KEY'
   WHERE t.table_schema NOT IN ('information_schema', 'mysql', 'performance_schema', 'sys')
   AND tc.constraint_name IS NULL;
   
   -- Analyze table fragmentation
   SELECT 
       table_name,
       ROUND(data_length/1024/1024, 2) AS data_mb,
       ROUND(data_free/1024/1024, 2) AS free_mb,
       ROUND((data_free/(data_length+index_length+data_free))*100, 2) AS fragmentation_percent
   FROM information_schema.tables
   WHERE table_schema = 'your_database'
   AND data_free > 0
   ORDER BY fragmentation_percent DESC;
   ```
   ```

## Usage Examples

```bash
# Analyze and suggest database indexes
/laravel-database-optimize --indexes

# Review migration files for optimization
/laravel-database-optimize --migrations database/migrations/

# Analyze complete database schema
/laravel-database-optimize --schema

# Optimize database queries performance
/laravel-database-optimize --queries

# MySQL-specific configuration optimization
/laravel-database-optimize --mysql-config
```

**Database Optimization Quality Standards:**
- All frequently queried columns should have appropriate indexes
- Foreign keys should have proper constraints and indexes
- Data types should be optimized for storage and performance
- Large table operations should use chunking
- Migration files should support zero-downtime deployment
- Database connections should be properly pooled
- Query performance should be regularly monitored
- MySQL configuration should be tuned for workload