# Laravel API Optimization

Implement API resource transformers, add proper API versioning structure, optimize JSON responses and pagination, implement rate limiting and throttling for robust API design.

## Instructions

Optimize Laravel API endpoints for performance and best practices: **$ARGUMENTS**

**Flags:**
- `--resources`: Implement API resource transformers
- `--versioning`: Add proper API versioning structure
- `--pagination`: Optimize API pagination and responses
- `--rate-limiting`: Implement rate limiting and throttling
- `--documentation`: Generate comprehensive API documentation

1. **API Architecture Assessment**
   ```markdown
   ## API Design Analysis
   
   ### Current API State Evaluation
   - **Response Structure**: Consistency across endpoints
   - **Resource Transformation**: Use of API resources vs raw models
   - **Versioning Strategy**: API version management approach
   - **Pagination**: Implementation and efficiency
   - **Error Handling**: Standardized error responses
   - **Rate Limiting**: Protection against abuse
   
   ### RESTful API Best Practices
   - Consistent resource naming conventions
   - Proper HTTP status codes
   - Standardized response format
   - Efficient data serialization
   - Comprehensive error handling
   ```

2. **API Resource Implementation**
   ```markdown
   ## Resource Transformer Architecture
   
   ### Comprehensive Resource Structure
   #### Base API Resource
   ```php
   <?php
   
   namespace App\Http\Resources;
   
   use Illuminate\Http\Request;
   use Illuminate\Http\Resources\Json\JsonResource;
   
   abstract class BaseResource extends JsonResource
   {
       /**
        * Transform the resource into an array.
        */
       public function toArray(Request $request): array
       {
           return [
               'id' => $this->id,
               'type' => $this->getResourceType(),
               'attributes' => $this->getAttributes($request),
               'relationships' => $this->when(
                   $this->shouldIncludeRelationships($request),
                   fn() => $this->getRelationships($request)
               ),
               'meta' => $this->when(
                   $this->shouldIncludeMeta($request),
                   fn() => $this->getMeta($request)
               ),
               'links' => [
                   'self' => $this->getSelfLink(),
               ],
           ];
       }
   
       abstract protected function getResourceType(): string;
       abstract protected function getAttributes(Request $request): array;
       
       protected function getRelationships(Request $request): array
       {
           return [];
       }
   
       protected function getMeta(Request $request): array
       {
           return [];
       }
   
       protected function shouldIncludeRelationships(Request $request): bool
       {
           return $request->has('include');
       }
   
       protected function shouldIncludeMeta(Request $request): bool
       {
           return false;
       }
   
       protected function getSelfLink(): string
       {
           return url("/api/v1/{$this->getResourceType()}/{$this->id}");
       }
   }
   ```
   
   #### User Resource Implementation
   ```php
   <?php
   
   namespace App\Http\Resources\V1;
   
   use App\Http\Resources\BaseResource;
   use Illuminate\Http\Request;
   
   class UserResource extends BaseResource
   {
       protected function getResourceType(): string
       {
           return 'users';
       }
   
       protected function getAttributes(Request $request): array
       {
           return [
               'name' => $this->name,
               'email' => $this->when(
                   $this->shouldShowEmail($request),
                   $this->email
               ),
               'avatar' => $this->avatar_url,
               'verified' => $this->hasVerifiedEmail(),
               'created_at' => $this->created_at->toISOString(),
               'updated_at' => $this->updated_at->toISOString(),
           ];
       }
   
       protected function getRelationships(Request $request): array
       {
           return [
               'posts' => PostResource::collection(
                   $this->whenLoaded('posts')
               ),
               'profile' => new ProfileResource(
                   $this->whenLoaded('profile')
               ),
               'permissions' => PermissionResource::collection(
                   $this->whenLoaded('permissions')
               ),
           ];
       }
   
       protected function getMeta(Request $request): array
       {
           return [
               'posts_count' => $this->when(
                   $this->relationLoaded('posts'),
                   fn() => $this->posts->count()
               ),
               'last_login' => $this->when(
                   $this->last_login_at,
                   fn() => $this->last_login_at->toISOString()
               ),
           ];
       }
   
       private function shouldShowEmail(Request $request): bool
       {
           return $request->user()?->can('view-user-email', $this->resource) ?? false;
       }
   }
   ```
   
   ### Resource Collection with Metadata
   ```php
   <?php
   
   namespace App\Http\Resources\V1;
   
   use Illuminate\Http\Request;
   use Illuminate\Http\Resources\Json\ResourceCollection;
   
   class UserCollection extends ResourceCollection
   {
       public function toArray(Request $request): array
       {
           return [
               'data' => $this->collection,
               'meta' => [
                   'total' => $this->total(),
                   'count' => $this->count(),
                   'per_page' => $this->perPage(),
                   'current_page' => $this->currentPage(),
                   'last_page' => $this->lastPage(),
                   'has_more_pages' => $this->hasMorePages(),
               ],
               'links' => [
                   'first' => $this->url(1),
                   'last' => $this->url($this->lastPage()),
                   'prev' => $this->previousPageUrl(),
                   'next' => $this->nextPageUrl(),
                   'self' => $this->url($this->currentPage()),
               ],
           ];
       }
   
       public function with(Request $request): array
       {
           return [
               'jsonapi' => [
                   'version' => '1.0',
               ],
               'meta' => [
                   'timestamp' => now()->toISOString(),
                   'request_id' => $request->header('X-Request-ID', str()->uuid()),
               ],
           ];
       }
   }
   ```
   ```

3. **API Versioning Strategy**
   ```markdown
   ## Version Management Architecture
   
   ### Route-Based Versioning Structure
   #### API Route Organization
   ```php
   // routes/api/v1.php
   <?php
   
   use App\Http\Controllers\Api\V1\AuthController;
   use App\Http\Controllers\Api\V1\UserController;
   use App\Http\Controllers\Api\V1\PostController;
   use Illuminate\Support\Facades\Route;
   
   Route::prefix('v1')->name('api.v1.')->group(function () {
       // Authentication routes
       Route::post('/auth/login', [AuthController::class, 'login']);
       Route::post('/auth/register', [AuthController::class, 'register']);
       Route::post('/auth/refresh', [AuthController::class, 'refresh']);
       
       // Protected routes
       Route::middleware(['auth:sanctum'])->group(function () {
           Route::post('/auth/logout', [AuthController::class, 'logout']);
           Route::get('/auth/me', [AuthController::class, 'me']);
           
           // User management
           Route::apiResource('users', UserController::class);
           Route::get('/users/{user}/posts', [UserController::class, 'posts']);
           
           // Posts
           Route::apiResource('posts', PostController::class);
           Route::post('/posts/{post}/like', [PostController::class, 'like']);
           Route::delete('/posts/{post}/like', [PostController::class, 'unlike']);
       });
   });
   ```
   
   ```php
   // routes/api/v2.php - Updated API version
   <?php
   
   use App\Http\Controllers\Api\V2\UserController;
   use App\Http\Controllers\Api\V2\PostController;
   use Illuminate\Support\Facades\Route;
   
   Route::prefix('v2')->name('api.v2.')->group(function () {
       Route::middleware(['auth:sanctum'])->group(function () {
           // Enhanced user endpoints
           Route::apiResource('users', UserController::class);
           Route::get('/users/{user}/activity', [UserController::class, 'activity']);
           Route::put('/users/{user}/preferences', [UserController::class, 'updatePreferences']);
           
           // Enhanced posts with new features
           Route::apiResource('posts', PostController::class);
           Route::post('/posts/{post}/reactions', [PostController::class, 'addReaction']);
           Route::get('/posts/{post}/analytics', [PostController::class, 'analytics']);
       });
   });
   ```
   
   ### Version-Specific Controllers
   ```php
   <?php
   
   namespace App\Http\Controllers\Api\V1;
   
   use App\Http\Controllers\Controller;
   use App\Http\Resources\V1\UserResource;
   use App\Http\Resources\V1\UserCollection;
   use App\Models\User;
   use Illuminate\Http\Request;
   
   class UserController extends Controller
   {
       public function index(Request $request): UserCollection
       {
           $users = User::with($this->getIncludes($request))
               ->filter($request->only(['search', 'status', 'role']))
               ->paginate($request->get('per_page', 15));
   
           return new UserCollection($users);
       }
   
       public function show(Request $request, User $user): UserResource
       {
           $user->load($this->getIncludes($request));
           
           return new UserResource($user);
       }
   
       public function store(StoreUserRequest $request): UserResource
       {
           $user = User::create($request->validated());
           
           return new UserResource($user);
       }
   
       public function update(UpdateUserRequest $request, User $user): UserResource
       {
           $user->update($request->validated());
           
           return new UserResource($user);
       }
   
       public function destroy(User $user): \Illuminate\Http\JsonResponse
       {
           $user->delete();
           
           return response()->json(null, 204);
       }
   
       private function getIncludes(Request $request): array
       {
           $includes = $request->get('include', '');
           $allowedIncludes = ['posts', 'profile', 'permissions'];
           
           return array_intersect(
               explode(',', $includes),
               $allowedIncludes
           );
       }
   }
   ```
   ```

4. **Pagination Optimization**
   ```markdown
   ## Advanced Pagination Strategies
   
   ### Cursor-Based Pagination
   #### High-Performance Pagination Service
   ```php
   <?php
   
   namespace App\Services\Api;
   
   use Illuminate\Database\Eloquent\Builder;
   use Illuminate\Http\Request;
   use Illuminate\Pagination\Paginator;
   
   class ApiPaginationService
   {
       public function paginateWithCursor(
           Builder $query,
           Request $request,
           string $column = 'id',
           int $perPage = 15
       ): array {
           $cursor = $request->get('cursor');
           $direction = $request->get('direction', 'next');
           
           if ($cursor) {
               if ($direction === 'next') {
                   $query->where($column, '>', $cursor);
               } else {
                   $query->where($column, '<', $cursor);
               }
           }
           
           $results = $query->orderBy($column, $direction === 'next' ? 'asc' : 'desc')
               ->limit($perPage + 1)
               ->get();
           
           $hasMore = $results->count() > $perPage;
           if ($hasMore) {
               $results->pop();
           }
           
           $nextCursor = $hasMore ? $results->last()->{$column} : null;
           $prevCursor = $results->first()->{$column} ?? null;
           
           return [
               'data' => $results,
               'meta' => [
                   'has_more' => $hasMore,
                   'per_page' => $perPage,
                   'count' => $results->count(),
               ],
               'links' => [
                   'next' => $nextCursor ? $this->buildCursorUrl($request, $nextCursor, 'next') : null,
                   'prev' => $prevCursor ? $this->buildCursorUrl($request, $prevCursor, 'prev') : null,
               ],
           ];
       }
   
       public function paginateWithOffset(
           Builder $query,
           Request $request,
           int $perPage = 15
       ): \Illuminate\Contracts\Pagination\LengthAwarePaginator {
           $page = $request->get('page', 1);
           
           return $query->paginate($perPage, ['*'], 'page', $page);
       }
   
       private function buildCursorUrl(Request $request, $cursor, string $direction): string
       {
           $params = array_merge($request->query(), [
               'cursor' => $cursor,
               'direction' => $direction,
           ]);
           
           return $request->url() . '?' . http_build_query($params);
       }
   }
   ```
   
   ### Efficient Search and Filtering
   ```php
   <?php
   
   namespace App\Http\Controllers\Api\V1;
   
   use App\Services\Api\ApiPaginationService;
   use App\Http\Resources\V1\PostCollection;
   use App\Models\Post;
   use Illuminate\Http\Request;
   
   class PostController extends Controller
   {
       public function __construct(
           private ApiPaginationService $paginationService
       ) {}
   
       public function index(Request $request): PostCollection
       {
           $query = Post::with(['author', 'tags'])
               ->when($request->get('search'), function ($q, $search) {
                   $q->where(function ($query) use ($search) {
                       $query->where('title', 'like', "%{$search}%")
                             ->orWhere('content', 'like', "%{$search}%")
                             ->orWhereHas('tags', function ($tagQuery) use ($search) {
                                 $tagQuery->where('name', 'like', "%{$search}%");
                             });
                   });
               })
               ->when($request->get('category'), function ($q, $category) {
                   $q->where('category_id', $category);
               })
               ->when($request->get('status'), function ($q, $status) {
                   $q->where('status', $status);
               })
               ->when($request->get('author'), function ($q, $author) {
                   $q->where('user_id', $author);
               })
               ->when($request->get('date_from'), function ($q, $dateFrom) {
                   $q->where('created_at', '>=', $dateFrom);
               })
               ->when($request->get('date_to'), function ($q, $dateTo) {
                   $q->where('created_at', '<=', $dateTo);
               });
   
           // Use cursor pagination for better performance on large datasets
           if ($request->has('cursor')) {
               $results = $this->paginationService->paginateWithCursor(
                   $query,
                   $request,
                   'created_at',
                   $request->get('per_page', 15)
               );
               
               return new PostCollection($results['data']);
           }
   
           // Standard offset pagination
           $posts = $this->paginationService->paginateWithOffset(
               $query,
               $request,
               $request->get('per_page', 15)
           );
   
           return new PostCollection($posts);
       }
   }
   ```
   ```

5. **Rate Limiting and Throttling**
   ```markdown
   ## API Protection and Rate Limiting
   
   ### Advanced Rate Limiting Implementation
   #### Custom Rate Limiting Service
   ```php
   <?php
   
   namespace App\Services\Api;
   
   use Illuminate\Http\Request;
   use Illuminate\Support\Facades\Cache;
   use Illuminate\Support\Facades\RateLimiter;
   
   class ApiRateLimitService
   {
       public function configureRateLimits(): void
       {
           // Public API endpoints
           RateLimiter::for('api_public', function (Request $request) {
               return \Illuminate\Cache\RateLimiting\Limit::perMinute(60)
                   ->by($request->ip());
           });
   
           // Authenticated API endpoints
           RateLimiter::for('api_authenticated', function (Request $request) {
               $user = $request->user();
               
               if (!$user) {
                   return \Illuminate\Cache\RateLimiting\Limit::perMinute(10)
                       ->by($request->ip());
               }
   
               // Different limits based on user plan
               return match($user->plan) {
                   'premium' => \Illuminate\Cache\RateLimiting\Limit::perMinute(1000)
                       ->by($user->id),
                   'business' => \Illuminate\Cache\RateLimiting\Limit::perMinute(500)
                       ->by($user->id),
                   default => \Illuminate\Cache\RateLimiting\Limit::perMinute(100)
                       ->by($user->id),
               };
           });
   
           // Sensitive operations (login, password reset)
           RateLimiter::for('api_sensitive', function (Request $request) {
               return \Illuminate\Cache\RateLimiting\Limit::perMinute(5)
                   ->by($request->ip())
                   ->response(function () {
                       return response()->json([
                           'error' => 'Too many attempts. Please try again later.',
                           'code' => 'RATE_LIMIT_EXCEEDED',
                           'retry_after' => 60,
                       ], 429);
                   });
           });
   
           // Search endpoints (expensive operations)
           RateLimiter::for('api_search', function (Request $request) {
               return \Illuminate\Cache\RateLimiting\Limit::perMinute(30)
                   ->by($request->user()?->id ?: $request->ip());
           });
       }
   
       public function checkCustomRateLimit(Request $request, string $key, int $maxAttempts, int $decayMinutes): bool
       {
           $attempts = Cache::get($key, 0);
           
           if ($attempts >= $maxAttempts) {
               return false;
           }
           
           Cache::put($key, $attempts + 1, now()->addMinutes($decayMinutes));
           
           return true;
       }
   
       public function getRemainingAttempts(Request $request, string $limiter): int
       {
           return RateLimiter::remaining($limiter, $request);
       }
   
       public function getResetTime(Request $request, string $limiter): int
       {
           return RateLimiter::availableIn($limiter);
       }
   }
   ```
   
   ### Rate Limiting Middleware
   ```php
   <?php
   
   namespace App\Http\Middleware;
   
   use App\Services\Api\ApiRateLimitService;
   use Closure;
   use Illuminate\Http\Request;
   use Illuminate\Support\Facades\RateLimiter;
   
   class ApiRateLimitMiddleware
   {
       public function __construct(
           private ApiRateLimitService $rateLimitService
       ) {}
   
       public function handle(Request $request, Closure $next, string $limiter = 'api_authenticated')
       {
           $key = $this->resolveRequestSignature($request, $limiter);
           
           if (RateLimiter::tooManyAttempts($key, $this->getMaxAttempts($limiter))) {
               return $this->buildRateLimitResponse($request, $key, $limiter);
           }
           
           RateLimiter::hit($key, $this->getDecayTime($limiter));
           
           $response = $next($request);
           
           // Add rate limit headers
           return $this->addRateLimitHeaders($response, $request, $limiter);
       }
   
       protected function resolveRequestSignature(Request $request, string $limiter): string
       {
           if ($request->user()) {
               return sha1($limiter . '|' . $request->user()->id);
           }
           
           return sha1($limiter . '|' . $request->ip());
       }
   
       protected function buildRateLimitResponse(Request $request, string $key, string $limiter): \Illuminate\Http\JsonResponse
       {
           $retryAfter = RateLimiter::availableIn($key);
           
           return response()->json([
               'error' => 'Rate limit exceeded',
               'message' => 'Too many requests. Please try again later.',
               'code' => 'RATE_LIMIT_EXCEEDED',
               'retry_after' => $retryAfter,
           ], 429)->withHeaders([
               'X-RateLimit-Limit' => $this->getMaxAttempts($limiter),
               'X-RateLimit-Remaining' => 0,
               'X-RateLimit-Reset' => now()->addSeconds($retryAfter)->timestamp,
               'Retry-After' => $retryAfter,
           ]);
       }
   
       protected function addRateLimitHeaders($response, Request $request, string $limiter)
       {
           $maxAttempts = $this->getMaxAttempts($limiter);
           $remaining = $this->rateLimitService->getRemainingAttempts($request, $limiter);
           $resetTime = now()->addSeconds($this->getDecayTime($limiter))->timestamp;
           
           return $response->withHeaders([
               'X-RateLimit-Limit' => $maxAttempts,
               'X-RateLimit-Remaining' => max(0, $remaining),
               'X-RateLimit-Reset' => $resetTime,
           ]);
       }
   
       protected function getMaxAttempts(string $limiter): int
       {
           return match($limiter) {
               'api_public' => 60,
               'api_authenticated' => 100,
               'api_sensitive' => 5,
               'api_search' => 30,
               default => 60,
           };
       }
   
       protected function getDecayTime(string $limiter): int
       {
           return 60; // 1 minute in seconds
       }
   }
   ```
   ```

6. **API Error Handling and Responses**
   ```markdown
   ## Standardized Error Handling
   
   ### API Exception Handler
   ```php
   <?php
   
   namespace App\Exceptions;
   
   use Illuminate\Auth\AuthenticationException;
   use Illuminate\Database\Eloquent\ModelNotFoundException;
   use Illuminate\Foundation\Exceptions\Handler as ExceptionHandler;
   use Illuminate\Http\Request;
   use Illuminate\Validation\ValidationException;
   use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
   use Throwable;
   
   class ApiExceptionHandler extends ExceptionHandler
   {
       public function render($request, Throwable $e)
       {
           if ($request->is('api/*')) {
               return $this->handleApiException($request, $e);
           }
   
           return parent::render($request, $e);
       }
   
       protected function handleApiException(Request $request, Throwable $e): \Illuminate\Http\JsonResponse
       {
           $response = [
               'error' => true,
               'message' => $e->getMessage(),
               'code' => $this->getErrorCode($e),
           ];
   
           if (app()->environment('local', 'testing')) {
               $response['debug'] = [
                   'exception' => get_class($e),
                   'file' => $e->getFile(),
                   'line' => $e->getLine(),
                   'trace' => $e->getTrace(),
               ];
           }
   
           return response()->json($response, $this->getStatusCode($e));
       }
   
       protected function getStatusCode(Throwable $e): int
       {
           return match(true) {
               $e instanceof ValidationException => 422,
               $e instanceof ModelNotFoundException,
               $e instanceof NotFoundHttpException => 404,
               $e instanceof AuthenticationException => 401,
               $e instanceof \Illuminate\Auth\Access\AuthorizationException => 403,
               default => 500,
           };
       }
   
       protected function getErrorCode(Throwable $e): string
       {
           return match(true) {
               $e instanceof ValidationException => 'VALIDATION_FAILED',
               $e instanceof ModelNotFoundException => 'RESOURCE_NOT_FOUND',
               $e instanceof NotFoundHttpException => 'ENDPOINT_NOT_FOUND',
               $e instanceof AuthenticationException => 'AUTHENTICATION_REQUIRED',
               $e instanceof \Illuminate\Auth\Access\AuthorizationException => 'INSUFFICIENT_PERMISSIONS',
               default => 'INTERNAL_SERVER_ERROR',
           };
       }
   }
   ```
   ```

## Usage Examples

```bash
# Implement API resource transformers
/laravel-api-optimize --resources

# Add proper API versioning
/laravel-api-optimize --versioning

# Optimize pagination and responses
/laravel-api-optimize --pagination

# Implement rate limiting
/laravel-api-optimize --rate-limiting

# Generate API documentation
/laravel-api-optimize --documentation
```

**API Optimization Quality Standards:**
- All API responses should use resource transformers
- APIs should support versioning for backward compatibility
- Pagination should be efficient for large datasets
- Rate limiting should protect against abuse
- Error responses should be consistent and informative
- API documentation should be comprehensive and up-to-date
- Authentication should be stateless and secure
- Performance should be optimized for high throughput