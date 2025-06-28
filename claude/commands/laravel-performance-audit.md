# Laravel Performance Audit

Identify performance bottlenecks, suggest caching strategies, optimize asset loading, review queue job implementations, and implement comprehensive performance monitoring.

## Instructions

Conduct thorough performance audit of Laravel application: **$ARGUMENTS**

**Flags:**
- `--caching`: Analyze and implement caching strategies
- `--assets`: Optimize asset loading and compilation
- `--queues`: Review and optimize queue job performance
- `--memory`: Analyze memory usage and optimization
- `--profiling`: Set up performance profiling and monitoring

1. **Performance Assessment Framework**
   ```markdown
   ## Application Performance Analysis
   
   ### Performance Metrics Collection
   - **Response Times**: Average, median, 95th percentile response times
   - **Memory Usage**: Peak memory consumption, memory leaks
   - **Database Performance**: Query count, execution time, N+1 problems
   - **Cache Efficiency**: Hit rates, cache usage patterns
   - **Asset Loading**: Bundle sizes, load times, optimization opportunities
   
   ### Performance Benchmarking
   ```php
   <?php
   
   namespace App\Services\Performance;
   
   use Illuminate\Support\Facades\DB;
   use Illuminate\Support\Facades\Cache;
   use Illuminate\Support\Facades\Log;
   
   class PerformanceMonitoringService
   {
       public function benchmarkEndpoint(string $endpoint, int $iterations = 100): array
       {
           $times = [];
           $memoryUsage = [];
           $queryCount = [];
   
           for ($i = 0; $i < $iterations; $i++) {
               $startTime = microtime(true);
               $startMemory = memory_get_usage(true);
               
               // Reset query count
               DB::flushQueryLog();
               DB::enableQueryLog();
               
               // Make request
               $response = $this->makeRequest($endpoint);
               
               $endTime = microtime(true);
               $endMemory = memory_get_usage(true);
               $queries = count(DB::getQueryLog());
               
               $times[] = ($endTime - $startTime) * 1000; // Convert to ms
               $memoryUsage[] = $endMemory - $startMemory;
               $queryCount[] = $queries;
               
               DB::disableQueryLog();
           }
   
           return [
               'response_time' => [
                   'average' => array_sum($times) / count($times),
                   'median' => $this->median($times),
                   'min' => min($times),
                   'max' => max($times),
                   'p95' => $this->percentile($times, 95),
               ],
               'memory_usage' => [
                   'average' => array_sum($memoryUsage) / count($memoryUsage),
                   'peak' => max($memoryUsage),
               ],
               'database_queries' => [
                   'average' => array_sum($queryCount) / count($queryCount),
                   'max' => max($queryCount),
               ],
           ];
       }
   
       private function median(array $values): float
       {
           sort($values);
           $count = count($values);
           $middle = floor(($count - 1) / 2);
           
           if ($count % 2) {
               return $values[$middle];
           }
           
           return ($values[$middle] + $values[$middle + 1]) / 2;
       }
   
       private function percentile(array $values, int $percentile): float
       {
           sort($values);
           $index = ($percentile / 100) * (count($values) - 1);
           
           if (floor($index) == $index) {
               return $values[$index];
           }
           
           $lower = $values[floor($index)];
           $upper = $values[ceil($index)];
           $fraction = $index - floor($index);
           
           return $lower + ($fraction * ($upper - $lower));
       }
   }
   ```
   ```

2. **Caching Strategy Implementation**
   ```markdown
   ## Multi-Layer Caching Architecture
   
   ### Cache Strategy Analysis
   #### Comprehensive Caching Service
   ```php
   <?php
   
   namespace App\Services\Cache;
   
   use Illuminate\Support\Facades\Cache;
   use Illuminate\Support\Facades\Redis;
   use Illuminate\Database\Eloquent\Model;
   
   class CachingStrategyService
   {
       // Cache layers: Application -> Redis -> Database
       private array $cacheConfig = [
           'user_data' => ['ttl' => 3600, 'tags' => ['users']],
           'product_catalog' => ['ttl' => 7200, 'tags' => ['products']],
           'blog_posts' => ['ttl' => 1800, 'tags' => ['posts']],
           'api_responses' => ['ttl' => 300, 'tags' => ['api']],
       ];
   
       public function cacheUserData(int $userId): array
       {
           return Cache::tags(['users'])->remember(
               "user_data_{$userId}",
               $this->cacheConfig['user_data']['ttl'],
               function () use ($userId) {
                   return [
                       'user' => User::with(['profile', 'preferences'])->find($userId),
                       'permissions' => $this->getUserPermissions($userId),
                       'recent_activity' => $this->getRecentActivity($userId, 10),
                   ];
               }
           );
       }
   
       public function cacheProductCatalog(array $filters = []): Collection
       {
           $cacheKey = 'products_' . md5(serialize($filters));
           
           return Cache::tags(['products'])->remember(
               $cacheKey,
               $this->cacheConfig['product_catalog']['ttl'],
               function () use ($filters) {
                   return Product::with(['category', 'images'])
                       ->when($filters['category'] ?? null, fn($q, $cat) => $q->where('category_id', $cat))
                       ->when($filters['featured'] ?? null, fn($q) => $q->where('featured', true))
                       ->when($filters['price_range'] ?? null, function($q, $range) {
                           $q->whereBetween('price', [$range['min'], $range['max']]);
                       })
                       ->orderBy('popularity', 'desc')
                       ->paginate(20);
               }
           );
       }
   
       public function invalidateUserCache(int $userId): void
       {
           Cache::tags(['users'])->flush();
           Cache::forget("user_data_{$userId}");
           Cache::forget("user_permissions_{$userId}");
       }
   
       public function getCacheStats(): array
       {
           return [
               'redis_info' => Redis::info(),
               'cache_hit_rate' => $this->calculateHitRate(),
               'memory_usage' => $this->getCacheMemoryUsage(),
               'key_distribution' => $this->getKeyDistribution(),
           ];
       }
   
       private function calculateHitRate(): float
       {
           $info = Redis::info();
           $hits = $info['keyspace_hits'] ?? 0;
           $misses = $info['keyspace_misses'] ?? 0;
           
           return $hits + $misses > 0 ? ($hits / ($hits + $misses)) * 100 : 0;
       }
   }
   ```
   
   ### Cache Warming and Preloading
   ```php
   <?php
   
   namespace App\Console\Commands;
   
   use App\Services\Cache\CachingStrategyService;
   use Illuminate\Console\Command;
   
   class WarmCacheCommand extends Command
   {
       protected $signature = 'cache:warm {--type=all}';
       protected $description = 'Warm application caches';
   
       public function __construct(
           private CachingStrategyService $cachingService
       ) {
           parent::__construct();
       }
   
       public function handle(): void
       {
           $type = $this->option('type');
           
           match($type) {
               'all' => $this->warmAllCaches(),
               'users' => $this->warmUserCaches(),
               'products' => $this->warmProductCaches(),
               'pages' => $this->warmPageCaches(),
               default => $this->warmAllCaches(),
           };
           
           $this->info('Cache warming completed!');
       }
   
       private function warmAllCaches(): void
       {
           $this->warmUserCaches();
           $this->warmProductCaches();
           $this->warmPageCaches();
       }
   
       private function warmUserCaches(): void
       {
           $this->info('Warming user caches...');
           
           // Cache active users data
           User::where('last_login_at', '>=', now()->subDays(7))
               ->chunk(100, function ($users) {
                   foreach ($users as $user) {
                       $this->cachingService->cacheUserData($user->id);
                   }
               });
       }
   
       private function warmProductCaches(): void
       {
           $this->info('Warming product caches...');
           
           // Common product filters
           $commonFilters = [
               [],
               ['featured' => true],
               ['category' => 1],
               ['category' => 2],
               ['price_range' => ['min' => 0, 'max' => 100]],
           ];
           
           foreach ($commonFilters as $filters) {
               $this->cachingService->cacheProductCatalog($filters);
           }
       }
   
       private function warmPageCaches(): void
       {
           $this->info('Warming page caches...');
           
           // Cache frequently accessed pages
           $pages = ['home', 'about', 'contact', 'pricing'];
           
           foreach ($pages as $page) {
               $this->call('route:cache');
               $this->call('view:cache');
           }
       }
   }
   ```
   ```

3. **Asset Optimization and Performance**
   ```markdown
   ## Frontend Performance Optimization
   
   ### Asset Compilation and Optimization
   #### Vite Configuration for Performance
   ```javascript
   // vite.config.js - Optimized for production
   import { defineConfig } from 'vite';
   import laravel from 'laravel-vite-plugin';
   import { resolve } from 'path';
   
   export default defineConfig({
       plugins: [
           laravel({
               input: [
                   'resources/css/app.css',
                   'resources/js/app.js',
                   'resources/js/admin.js',
               ],
               refresh: true,
           }),
       ],
       build: {
           // Code splitting for better caching
           rollupOptions: {
               output: {
                   manualChunks: {
                       vendor: ['lodash', 'axios'],
                       ui: ['alpinejs', 'tailwindcss'],
                   },
               },
           },
           // Minification and compression
           minify: 'terser',
           terserOptions: {
               compress: {
                   drop_console: true,
                   drop_debugger: true,
               },
           },
           // Asset size limits
           chunkSizeWarningLimit: 1000,
           assetsInlineLimit: 4096,
       },
       css: {
           // CSS optimization
           postcss: {
               plugins: [
                   require('cssnano')({
                       preset: 'default',
                   }),
               ],
           },
       },
       server: {
           hmr: {
               host: 'localhost',
           },
       },
   });
   ```
   
   ### Image Optimization Service
   ```php
   <?php
   
   namespace App\Services\Media;
   
   use Illuminate\Http\UploadedFile;
   use Illuminate\Support\Facades\Storage;
   use Intervention\Image\Facades\Image;
   
   class ImageOptimizationService
   {
       private array $sizes = [
           'thumbnail' => ['width' => 150, 'height' => 150],
           'medium' => ['width' => 300, 'height' => 300],
           'large' => ['width' => 800, 'height' => 600],
           'hero' => ['width' => 1200, 'height' => 800],
       ];
   
       public function processAndOptimizeImage(UploadedFile $file, string $path): array
       {
           $originalPath = $this->storeOriginal($file, $path);
           $optimizedVersions = [];
   
           foreach ($this->sizes as $sizeName => $dimensions) {
               $optimizedPath = $this->createOptimizedVersion(
                   $originalPath,
                   $sizeName,
                   $dimensions
               );
               $optimizedVersions[$sizeName] = $optimizedPath;
           }
   
           // Create WebP versions for modern browsers
           $webpVersions = $this->createWebPVersions($optimizedVersions);
   
           return [
               'original' => $originalPath,
               'sizes' => $optimizedVersions,
               'webp' => $webpVersions,
               'metadata' => $this->extractMetadata($originalPath),
           ];
       }
   
       private function createOptimizedVersion(string $originalPath, string $sizeName, array $dimensions): string
       {
           $image = Image::make(Storage::path($originalPath));
           
           // Resize while maintaining aspect ratio
           $image->resize($dimensions['width'], $dimensions['height'], function ($constraint) {
               $constraint->aspectRatio();
               $constraint->upsize();
           });
           
           // Optimize quality based on size
           $quality = match($sizeName) {
               'thumbnail' => 70,
               'medium' => 80,
               'large' => 85,
               'hero' => 90,
               default => 80,
           };
           
           $optimizedPath = str_replace('.jpg', "_{$sizeName}.jpg", $originalPath);
           $image->save(Storage::path($optimizedPath), $quality);
           
           return $optimizedPath;
       }
   
       private function createWebPVersions(array $imagePaths): array
       {
           $webpVersions = [];
           
           foreach ($imagePaths as $sizeName => $path) {
               $webpPath = str_replace('.jpg', '.webp', $path);
               $image = Image::make(Storage::path($path));
               $image->encode('webp', 85);
               $image->save(Storage::path($webpPath));
               $webpVersions[$sizeName] = $webpPath;
           }
           
           return $webpVersions;
       }
   }
   ```
   ```

4. **Queue Performance Optimization**
   ```markdown
   ## Queue System Performance
   
   ### Queue Job Optimization
   #### High-Performance Job Implementation
   ```php
   <?php
   
   namespace App\Jobs;
   
   use App\Models\User;
   use App\Services\Email\EmailService;
   use Illuminate\Bus\Queueable;
   use Illuminate\Contracts\Queue\ShouldQueue;
   use Illuminate\Foundation\Bus\Dispatchable;
   use Illuminate\Queue\InteractsWithQueue;
   use Illuminate\Queue\SerializesModels;
   use Illuminate\Support\Facades\Log;
   
   class OptimizedEmailJob implements ShouldQueue
   {
       use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
   
       public int $tries = 3;
       public int $maxExceptions = 1;
       public int $timeout = 300; // 5 minutes
       public int $backoff = 60; // 1 minute backoff
   
       public function __construct(
           private int $userId,
           private string $emailType,
           private array $emailData = []
       ) {
           // Use queue with appropriate priority
           $this->onQueue($this->determineQueue($emailType));
       }
   
       public function handle(EmailService $emailService): void
       {
           $startTime = microtime(true);
           
           try {
               $user = User::find($this->userId);
               
               if (!$user) {
                   Log::warning("User not found for email job: {$this->userId}");
                   return;
               }
   
               // Check if user still wants this email type
               if (!$user->wantsEmailType($this->emailType)) {
                   Log::info("User opted out of email type: {$this->emailType}");
                   return;
               }
   
               $emailService->sendEmail($user, $this->emailType, $this->emailData);
               
               $duration = (microtime(true) - $startTime) * 1000;
               Log::info("Email job completed", [
                   'user_id' => $this->userId,
                   'email_type' => $this->emailType,
                   'duration_ms' => $duration,
               ]);
               
           } catch (\Exception $e) {
               Log::error("Email job failed", [
                   'user_id' => $this->userId,
                   'email_type' => $this->emailType,
                   'error' => $e->getMessage(),
                   'attempt' => $this->attempts(),
               ]);
               
               throw $e;
           }
       }
   
       public function failed(\Throwable $exception): void
       {
           Log::error("Email job permanently failed", [
               'user_id' => $this->userId,
               'email_type' => $this->emailType,
               'error' => $exception->getMessage(),
           ]);
           
           // Notify administrators of critical email failures
           if ($this->emailType === 'critical') {
               // Send alert to admin
           }
       }
   
       private function determineQueue(string $emailType): string
       {
           return match($emailType) {
               'critical', 'password_reset', 'verification' => 'high',
               'notification', 'order_update' => 'default',
               'newsletter', 'marketing' => 'low',
               default => 'default',
           };
       }
   
       public function retryUntil(): \DateTime
       {
           return now()->addMinutes(10);
       }
   }
   ```
   
   ### Batch Job Processing
   ```php
   <?php
   
   namespace App\Jobs;
   
   use App\Models\User;
   use Illuminate\Bus\Batchable;
   use Illuminate\Bus\Queueable;
   use Illuminate\Contracts\Queue\ShouldQueue;
   use Illuminate\Foundation\Bus\Dispatchable;
   use Illuminate\Queue\InteractsWithQueue;
   use Illuminate\Queue\SerializesModels;
   use Illuminate\Support\Facades\Bus;
   
   class ProcessUsersBatchJob implements ShouldQueue
   {
       use Batchable, Dispatchable, InteractsWithQueue, Queueable, SerializesModels;
   
       public function __construct(
           private array $userIds,
           private string $operation
       ) {}
   
       public function handle(): void
       {
           if ($this->batch()->cancelled()) {
               return;
           }
   
           foreach ($this->userIds as $userId) {
               if ($this->batch()->cancelled()) {
                   break;
               }
   
               $this->processUser($userId);
           }
       }
   
       private function processUser(int $userId): void
       {
           $user = User::find($userId);
           
           if (!$user) {
               return;
           }
   
           match($this->operation) {
               'export_data' => $this->exportUserData($user),
               'send_newsletter' => $this->sendNewsletter($user),
               'update_preferences' => $this->updatePreferences($user),
               default => null,
           };
       }
   
       public static function dispatchBatch(array $allUserIds, string $operation): void
       {
           $chunks = array_chunk($allUserIds, 100); // Process 100 users per job
           
           $jobs = collect($chunks)->map(function ($chunk) use ($operation) {
               return new self($chunk, $operation);
           });
   
           $batch = Bus::batch($jobs)
               ->name("Process Users: {$operation}")
               ->allowFailures()
               ->onQueue('batch')
               ->dispatch();
   
           Log::info("Batch job dispatched", [
               'batch_id' => $batch->id,
               'operation' => $operation,
               'total_jobs' => $jobs->count(),
               'total_users' => count($allUserIds),
           ]);
       }
   }
   ```
   ```

5. **Memory Usage Optimization**
   ```markdown
   ## Memory Management and Optimization
   
   ### Memory-Efficient Data Processing
   #### Large Dataset Processing Service
   ```php
   <?php
   
   namespace App\Services\Performance;
   
   use Illuminate\Support\LazyCollection;
   use Illuminate\Database\Eloquent\Builder;
   
   class MemoryOptimizedService
   {
       public function processLargeDataset(Builder $query, callable $processor): void
       {
           // Use lazy collections to avoid loading all data into memory
           $query->lazy(1000)->each(function ($model) use ($processor) {
               $processor($model);
               
               // Force garbage collection every 1000 records
               if ($model->getKey() % 1000 === 0) {
                   if (function_exists('gc_collect_cycles')) {
                       gc_collect_cycles();
                   }
               }
           });
       }
   
       public function exportLargeDataset(Builder $query, string $filename): void
       {
           $handle = fopen(storage_path("exports/{$filename}"), 'w');
           
           // Write CSV header
           fputcsv($handle, ['ID', 'Name', 'Email', 'Created At']);
           
           $query->select(['id', 'name', 'email', 'created_at'])
               ->chunk(1000, function ($records) use ($handle) {
                   foreach ($records as $record) {
                       fputcsv($handle, $record->toArray());
                   }
                   
                   // Clear memory after each chunk
                   unset($records);
               });
           
           fclose($handle);
       }
   
       public function getMemoryUsageStats(): array
       {
           return [
               'current_usage' => $this->formatBytes(memory_get_usage(true)),
               'peak_usage' => $this->formatBytes(memory_get_peak_usage(true)),
               'memory_limit' => ini_get('memory_limit'),
               'available_memory' => $this->getAvailableMemory(),
           ];
       }
   
       private function formatBytes(int $bytes): string
       {
           $units = ['B', 'KB', 'MB', 'GB', 'TB'];
           
           for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
               $bytes /= 1024;
           }
           
           return round($bytes, 2) . ' ' . $units[$i];
       }
   
       private function getAvailableMemory(): string
       {
           $limit = $this->parseMemoryLimit(ini_get('memory_limit'));
           $used = memory_get_usage(true);
           
           return $this->formatBytes($limit - $used);
       }
   
       private function parseMemoryLimit(string $limit): int
       {
           $limit = trim($limit);
           $last = strtolower($limit[strlen($limit) - 1]);
           $limit = (int) $limit;
           
           switch ($last) {
               case 'g':
                   $limit *= 1024;
               case 'm':
                   $limit *= 1024;
               case 'k':
                   $limit *= 1024;
           }
           
           return $limit;
       }
   }
   ```
   ```

6. **Performance Monitoring and Profiling**
   ```markdown
   ## Application Performance Monitoring
   
   ### Performance Profiling Middleware
   #### Request Performance Tracking
   ```php
   <?php
   
   namespace App\Http\Middleware;
   
   use Closure;
   use Illuminate\Http\Request;
   use Illuminate\Support\Facades\DB;
   use Illuminate\Support\Facades\Log;
   
   class PerformanceProfilerMiddleware
   {
       public function handle(Request $request, Closure $next)
       {
           $startTime = microtime(true);
           $startMemory = memory_get_usage(true);
           
           // Enable query logging
           DB::enableQueryLog();
           
           $response = $next($request);
           
           $endTime = microtime(true);
           $endMemory = memory_get_usage(true);
           $queries = DB::getQueryLog();
           
           $metrics = [
               'url' => $request->fullUrl(),
               'method' => $request->method(),
               'response_time_ms' => round(($endTime - $startTime) * 1000, 2),
               'memory_usage_mb' => round(($endMemory - $startMemory) / 1024 / 1024, 2),
               'peak_memory_mb' => round(memory_get_peak_usage(true) / 1024 / 1024, 2),
               'query_count' => count($queries),
               'query_time_ms' => round(array_sum(array_column($queries, 'time')), 2),
               'status_code' => $response->getStatusCode(),
               'user_id' => auth()->id(),
           ];
           
           // Log slow requests
           if ($metrics['response_time_ms'] > 1000) {
               Log::warning('Slow request detected', $metrics);
           }
           
           // Log requests with many queries
           if ($metrics['query_count'] > 20) {
               Log::warning('Request with excessive queries', $metrics);
           }
           
           // Add performance headers for debugging
           if (app()->environment('local')) {
               $response->headers->set('X-Response-Time', $metrics['response_time_ms'] . 'ms');
               $response->headers->set('X-Memory-Usage', $metrics['memory_usage_mb'] . 'MB');
               $response->headers->set('X-Query-Count', $metrics['query_count']);
           }
           
           DB::disableQueryLog();
           
           return $response;
       }
   }
   ```
   
   ### Performance Analytics Service
   ```php
   <?php
   
   namespace App\Services\Performance;
   
   use Illuminate\Support\Facades\Redis;
   use Carbon\Carbon;
   
   class PerformanceAnalyticsService
   {
       public function recordMetric(string $metric, float $value, array $tags = []): void
       {
           $timestamp = now()->timestamp;
           $key = "metrics:{$metric}:" . date('Y-m-d-H', $timestamp);
           
           Redis::zadd($key, $timestamp, json_encode([
               'value' => $value,
               'tags' => $tags,
               'timestamp' => $timestamp,
           ]));
           
           // Expire old metrics after 30 days
           Redis::expire($key, 30 * 24 * 60 * 60);
       }
   
       public function getMetricStats(string $metric, Carbon $from, Carbon $to): array
       {
           $keys = $this->getMetricKeys($metric, $from, $to);
           $values = [];
           
           foreach ($keys as $key) {
               $data = Redis::zrangebyscore($key, $from->timestamp, $to->timestamp);
               foreach ($data as $item) {
                   $decoded = json_decode($item, true);
                   $values[] = $decoded['value'];
               }
           }
           
           if (empty($values)) {
               return ['count' => 0];
           }
           
           sort($values);
           
           return [
               'count' => count($values),
               'min' => min($values),
               'max' => max($values),
               'average' => array_sum($values) / count($values),
               'median' => $this->median($values),
               'p95' => $this->percentile($values, 95),
               'p99' => $this->percentile($values, 99),
           ];
       }
   
       public function generatePerformanceReport(Carbon $from, Carbon $to): array
       {
           return [
               'response_times' => $this->getMetricStats('response_time', $from, $to),
               'memory_usage' => $this->getMetricStats('memory_usage', $from, $to),
               'query_counts' => $this->getMetricStats('query_count', $from, $to),
               'cache_hit_rate' => $this->getCacheHitRate($from, $to),
               'error_rate' => $this->getErrorRate($from, $to),
           ];
       }
   }
   ```
   ```

## Usage Examples

```bash
# Analyze caching strategies
/laravel-performance-audit --caching

# Optimize asset loading and compilation
/laravel-performance-audit --assets

# Review queue job performance
/laravel-performance-audit --queues

# Analyze memory usage patterns
/laravel-performance-audit --memory

# Set up performance profiling
/laravel-performance-audit --profiling
```

**Performance Audit Quality Standards:**
- Response times should be under 200ms for most requests
- Memory usage should be optimized for large datasets
- Cache hit rates should exceed 80%
- Database queries should be under 20 per request
- Asset bundles should be under 1MB
- Queue jobs should complete within expected timeframes
- Performance monitoring should be comprehensive
- Bottlenecks should be identified and resolved