# Laravel Security Audit

Comprehensive security audit for Laravel applications including mass assignment vulnerabilities, environment configuration, middleware protection, and authentication/authorization patterns.

## Instructions

Conduct thorough security audit of Laravel application: **$ARGUMENTS**

**Flags:**
- `--mass-assignment`: Check for mass assignment vulnerabilities
- `--env-config`: Audit environment and configuration security
- `--auth-system`: Review authentication and authorization implementation
- `--middleware`: Analyze middleware security and route protection
- `--input-validation`: Check input validation and sanitization
- `--output-report`: Generate detailed security report

1. **Security Assessment Framework**
   ```markdown
   ## Security Audit Scope
   
   ### Critical Security Areas
   - **Authentication & Authorization**: Login, permissions, role management
   - **Input Validation**: Request validation, sanitization, filtering
   - **Mass Assignment**: Model protection, fillable/guarded configuration
   - **SQL Injection**: Query parameterization, raw query usage
   - **XSS Protection**: Output escaping, content security policy
   - **CSRF Protection**: Token validation, SameSite cookies
   - **Environment Security**: Configuration, secrets management
   - **File Upload Security**: Type validation, storage protection
   
   ### Security Compliance Checklist
   - OWASP Top 10 compliance
   - Laravel security best practices
   - Data protection regulations (GDPR, CCPA)
   - Industry-specific security standards
   ```

2. **Mass Assignment Vulnerability Detection**
   ```markdown
   ## Mass Assignment Security Analysis
   
   ### Vulnerable Patterns Detection
   #### Unsafe Mass Assignment
   ```php
   // VULNERABLE: No protection against mass assignment
   class User extends Model
   {
       // No $fillable or $guarded defined
   }
   
   // Controller creating user without validation
   public function store(Request $request)
   {
       // DANGER: All request data passed directly
       $user = User::create($request->all());
   }
   ```
   
   #### Secure Mass Assignment Implementation
   ```php
   // SECURE: Properly protected model
   class User extends Model
   {
       protected $fillable = [
           'name',
           'email',
           'password',
       ];
   
       // Critical fields protected
       protected $guarded = [
           'id',
           'is_admin',
           'email_verified_at',
           'remember_token',
       ];
   
       // Hidden from serialization
       protected $hidden = [
           'password',
           'remember_token',
           'two_factor_secret',
       ];
   }
   
   // SECURE: Validated input only
   public function store(CreateUserRequest $request)
   {
       $user = User::create($request->validated());
   }
   ```
   
   ### Mass Assignment Audit Checklist
   #### Model Security Review
   ```php
   // Check all models for proper protection
   foreach (Model::getAllModels() as $model) {
       $analysis = [
           'model' => get_class($model),
           'has_fillable' => !empty($model->getFillable()),
           'has_guarded' => !empty($model->getGuarded()),
           'protection_level' => $this->assessProtectionLevel($model),
           'risk_level' => $this->calculateRiskLevel($model),
       ];
   }
   
   // Identify high-risk models
   $highRiskModels = [
       'User', 'Role', 'Permission', 'Payment', 'Order'
   ];
   ```
   ```

3. **Authentication and Authorization Security**
   ```markdown
   ## Auth System Security Audit
   
   ### Authentication Security Review
   #### Secure Authentication Implementation
   ```php
   // SECURE: Rate limiting on login attempts
   Route::post('/login', [AuthController::class, 'login'])
       ->middleware(['throttle:5,1']); // 5 attempts per minute
   
   // SECURE: Strong password requirements
   class RegisterRequest extends FormRequest
   {
       public function rules(): array
       {
           return [
               'password' => [
                   'required',
                   'string',
                   'min:12',
                   'confirmed',
                   Rules\Password::min(12)
                       ->letters()
                       ->mixedCase()
                       ->numbers()
                       ->symbols()
                       ->uncompromised(),
               ],
           ];
       }
   }
   
   // SECURE: Account lockout after failed attempts
   class LoginController extends Controller
   {
       public function login(Request $request)
       {
           $credentials = $request->validate([
               'email' => 'required|email',
               'password' => 'required',
           ]);
   
           // Check for account lockout
           if ($this->hasTooManyLoginAttempts($request)) {
               $this->fireLockoutEvent($request);
               return $this->sendLockoutResponse($request);
           }
   
           if (Auth::attempt($credentials, $request->boolean('remember'))) {
               $this->clearLoginAttempts($request);
               $request->session()->regenerate();
               
               return redirect()->intended('dashboard');
           }
   
           $this->incrementLoginAttempts($request);
           
           return back()->withErrors([
               'email' => 'The provided credentials do not match our records.',
           ]);
       }
   }
   ```
   
   ### Authorization Security Patterns
   #### Policy-Based Authorization
   ```php
   // SECURE: Comprehensive policy implementation
   class PostPolicy
   {
       public function viewAny(User $user): bool
       {
           return $user->hasPermission('view-posts');
       }
   
       public function view(User $user, Post $post): bool
       {
           return $user->hasPermission('view-posts') 
               && ($post->published || $this->update($user, $post));
       }
   
       public function create(User $user): bool
       {
           return $user->hasPermission('create-posts');
       }
   
       public function update(User $user, Post $post): bool
       {
           return $user->hasPermission('edit-posts') 
               && ($user->id === $post->user_id || $user->hasRole('admin'));
       }
   
       public function delete(User $user, Post $post): bool
       {
           return $user->hasPermission('delete-posts')
               && ($user->id === $post->user_id || $user->hasRole('admin'));
       }
   }
   
   // SECURE: Route protection with policies
   Route::resource('posts', PostController::class)
       ->middleware(['auth', 'verified']);
   
   // In controller
   public function show(Post $post)
   {
       $this->authorize('view', $post);
       return view('posts.show', compact('post'));
   }
   ```
   ```

4. **Input Validation and Sanitization Security**
   ```markdown
   ## Input Security Analysis
   
   ### XSS Prevention Implementation
   #### Secure Output Handling
   ```php
   // SECURE: Proper output escaping in Blade
   {{-- Automatic escaping (safe) --}}
   <h1>{{ $post->title }}</h1>
   <p>{{ $post->content }}</p>
   
   {{-- Raw output (use carefully) --}}
   <div>{!! Purifier::clean($post->rich_content) !!}</div>
   
   // SECURE: Input sanitization
   class CreatePostRequest extends FormRequest
   {
       public function rules(): array
       {
           return [
               'title' => 'required|string|max:255',
               'content' => 'required|string',
               'rich_content' => 'nullable|string',
           ];
       }
   
       protected function prepareForValidation(): void
       {
           $this->merge([
               'title' => strip_tags($this->title),
               'content' => strip_tags($this->content),
               'rich_content' => Purifier::clean($this->rich_content),
           ]);
       }
   }
   ```
   
   ### SQL Injection Prevention
   #### Secure Database Queries
   ```php
   // VULNERABLE: Raw SQL with user input
   $users = DB::select("SELECT * FROM users WHERE name = '{$request->name}'");
   
   // SECURE: Parameterized queries
   $users = DB::select('SELECT * FROM users WHERE name = ?', [$request->name]);
   
   // SECURE: Eloquent ORM (automatically parameterized)
   $users = User::where('name', $request->name)->get();
   
   // SECURE: Raw queries with bindings
   $users = DB::table('users')
       ->whereRaw('LOWER(name) = LOWER(?)', [$request->name])
       ->get();
   ```
   ```

5. **Environment and Configuration Security**
   ```markdown
   ## Environment Security Audit
   
   ### Secure Configuration Patterns
   #### Environment Variables Security
   ```php
   // .env security checklist
   /*
   ✓ APP_DEBUG=false (in production)
   ✓ APP_ENV=production
   ✓ Strong APP_KEY (32 characters)
   ✓ Secure database credentials
   ✓ HTTPS-only session configuration
   ✓ Secure cache/session drivers
   ✓ Strong JWT secrets
   ✓ API keys properly secured
   */
   
   // config/app.php - Production security
   return [
       'debug' => env('APP_DEBUG', false),
       'env' => env('APP_ENV', 'production'),
       'key' => env('APP_KEY'),
       'cipher' => 'AES-256-CBC',
   ];
   
   // config/session.php - Secure session configuration
   return [
       'driver' => env('SESSION_DRIVER', 'redis'),
       'lifetime' => 120,
       'expire_on_close' => true,
       'encrypt' => true,
       'files' => storage_path('framework/sessions'),
       'connection' => null,
       'table' => 'sessions',
       'store' => null,
       'lottery' => [2, 100],
       'cookie' => env('SESSION_COOKIE', 'laravel_session'),
       'path' => '/',
       'domain' => env('SESSION_DOMAIN', null),
       'secure' => env('SESSION_SECURE_COOKIE', true),
       'http_only' => true,
       'same_site' => 'strict',
   ];
   ```
   
   ### Secrets Management
   #### Secure Secrets Handling
   ```php
   // SECURE: Environment-based configuration
   class PaymentService
   {
       private string $apiKey;
       private string $webhookSecret;
   
       public function __construct()
       {
           $this->apiKey = config('services.payment.api_key');
           $this->webhookSecret = config('services.payment.webhook_secret');
           
           if (!$this->apiKey || !$this->webhookSecret) {
               throw new InvalidConfigurationException('Payment configuration missing');
           }
       }
   }
   
   // config/services.php
   return [
       'payment' => [
           'api_key' => env('PAYMENT_API_KEY'),
           'webhook_secret' => env('PAYMENT_WEBHOOK_SECRET'),
           'sandbox' => env('PAYMENT_SANDBOX', false),
       ],
   ];
   ```
   ```

6. **File Upload Security**
   ```markdown
   ## File Upload Security Implementation
   
   ### Secure File Upload Handling
   #### Safe File Upload Service
   ```php
   <?php
   
   namespace App\Services;
   
   use Illuminate\Http\UploadedFile;
   use Illuminate\Support\Facades\Storage;
   use Illuminate\Support\Str;
   
   class SecureFileUploadService
   {
       private array $allowedMimeTypes = [
           'image/jpeg',
           'image/png',
           'image/gif',
           'application/pdf',
           'text/plain',
       ];
   
       private array $allowedExtensions = [
           'jpg', 'jpeg', 'png', 'gif', 'pdf', 'txt'
       ];
   
       private int $maxFileSize = 5 * 1024 * 1024; // 5MB
   
       public function uploadFile(UploadedFile $file, string $directory = 'uploads'): string
       {
           $this->validateFile($file);
           
           $filename = $this->generateSecureFilename($file);
           $path = $directory . '/' . $filename;
           
           // Store in private disk by default
           Storage::disk('private')->put($path, file_get_contents($file->path()));
           
           // Additional security: scan file for malware (if service available)
           if (config('security.virus_scanning_enabled')) {
               $this->scanFileForMalware(Storage::disk('private')->path($path));
           }
           
           return $path;
       }
   
       private function validateFile(UploadedFile $file): void
       {
           // Check file size
           if ($file->getSize() > $this->maxFileSize) {
               throw new InvalidFileException('File size exceeds limit');
           }
   
           // Validate MIME type
           if (!in_array($file->getMimeType(), $this->allowedMimeTypes)) {
               throw new InvalidFileException('File type not allowed');
           }
   
           // Validate extension
           $extension = strtolower($file->getClientOriginalExtension());
           if (!in_array($extension, $this->allowedExtensions)) {
               throw new InvalidFileException('File extension not allowed');
           }
   
           // Additional check: verify file header matches extension
           if (!$this->verifyFileHeader($file)) {
               throw new InvalidFileException('File header does not match extension');
           }
       }
   
       private function generateSecureFilename(UploadedFile $file): string
       {
           $extension = $file->getClientOriginalExtension();
           return Str::random(40) . '.' . $extension;
       }
   
       private function verifyFileHeader(UploadedFile $file): bool
       {
           $handle = fopen($file->path(), 'rb');
           $header = fread($handle, 10);
           fclose($handle);
   
           $mimeType = $file->getMimeType();
           
           // Basic file header validation
           return match($mimeType) {
               'image/jpeg' => str_starts_with($header, "\xFF\xD8\xFF"),
               'image/png' => str_starts_with($header, "\x89PNG\r\n\x1A\n"),
               'application/pdf' => str_starts_with($header, "%PDF"),
               default => true, // Allow other validated types
           };
       }
   }
   ```
   ```

7. **CSRF and Security Headers**
   ```markdown
   ## Web Security Headers Implementation
   
   ### CSRF Protection Configuration
   #### Secure CSRF Implementation
   ```php
   // config/session.php - CSRF configuration
   return [
       'same_site' => 'strict',
       'secure' => env('SESSION_SECURE_COOKIE', true),
       'http_only' => true,
   ];
   
   // Middleware for API CSRF exemption
   protected $except = [
       'api/*',
       'webhooks/*',
   ];
   
   // In Blade templates
   <form method="POST" action="/posts">
       @csrf
       <!-- form fields -->
   </form>
   
   // For AJAX requests
   <meta name="csrf-token" content="{{ csrf_token() }}">
   <script>
   $.ajaxSetup({
       headers: {
           'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
       }
   });
   </script>
   ```
   
   ### Security Headers Middleware
   ```php
   <?php
   
   namespace App\Http\Middleware;
   
   use Closure;
   use Illuminate\Http\Request;
   
   class SecurityHeadersMiddleware
   {
       public function handle(Request $request, Closure $next)
       {
           $response = $next($request);
   
           // Security headers
           $response->headers->set('X-Content-Type-Options', 'nosniff');
           $response->headers->set('X-Frame-Options', 'DENY');
           $response->headers->set('X-XSS-Protection', '1; mode=block');
           $response->headers->set('Referrer-Policy', 'strict-origin-when-cross-origin');
           $response->headers->set('Permissions-Policy', 'geolocation=(), microphone=(), camera=()');
           
           // HTTPS enforcement
           if (app()->environment('production')) {
               $response->headers->set('Strict-Transport-Security', 'max-age=31536000; includeSubDomains');
           }
   
           // Content Security Policy
           $csp = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:;";
           $response->headers->set('Content-Security-Policy', $csp);
   
           return $response;
       }
   }
   ```
   ```

8. **Security Monitoring and Logging**
   ```markdown
   ## Security Event Monitoring
   
   ### Security Event Logging
   #### Comprehensive Security Logging
   ```php
   <?php
   
   namespace App\Services;
   
   use Illuminate\Support\Facades\Log;
   use Illuminate\Http\Request;
   
   class SecurityAuditService
   {
       public function logSecurityEvent(string $event, array $context = []): void
       {
           Log::channel('security')->info($event, array_merge($context, [
               'ip' => request()->ip(),
               'user_agent' => request()->userAgent(),
               'user_id' => auth()->id(),
               'timestamp' => now()->toISOString(),
           ]));
       }
   
       public function logFailedLogin(Request $request): void
       {
           $this->logSecurityEvent('failed_login_attempt', [
               'email' => $request->input('email'),
               'ip' => $request->ip(),
               'attempts' => $this->getLoginAttempts($request),
           ]);
       }
   
       public function logSuspiciousActivity(string $activity, array $details = []): void
       {
           $this->logSecurityEvent('suspicious_activity', [
               'activity' => $activity,
               'details' => $details,
               'severity' => 'high',
           ]);
           
           // Notify security team for high-severity events
           if ($this->isHighSeverity($activity)) {
               $this->notifySecurityTeam($activity, $details);
           }
       }
   
       public function logPrivilegeEscalation(int $userId, string $action): void
       {
           $this->logSecurityEvent('privilege_escalation_attempt', [
               'target_user_id' => $userId,
               'attempted_action' => $action,
               'severity' => 'critical',
           ]);
       }
   }
   ```
   ```

## Usage Examples

```bash
# Complete security audit
/laravel-security-audit

# Focus on mass assignment vulnerabilities
/laravel-security-audit --mass-assignment app/Models/

# Audit environment configuration
/laravel-security-audit --env-config

# Review authentication system
/laravel-security-audit --auth-system app/Http/Controllers/Auth/

# Check middleware and route protection
/laravel-security-audit --middleware

# Generate comprehensive security report
/laravel-security-audit --output-report security-audit-$(date +%Y%m%d).md
```

**Security Audit Quality Standards:**
- All models must have proper mass assignment protection
- Authentication must include rate limiting and account lockout
- All user inputs must be validated and sanitized
- Environment variables must be properly secured
- File uploads must be restricted and validated
- Security headers must be implemented
- Security events must be logged and monitored
- OWASP Top 10 vulnerabilities must be addressed