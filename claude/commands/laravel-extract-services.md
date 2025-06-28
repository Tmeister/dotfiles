# Laravel Service Class Extraction

Extract business logic from controllers and models into dedicated service classes, implement dependency injection patterns, and create service provider bindings following Laravel best practices.

## Instructions

Extract and organize business logic into service classes: **$ARGUMENTS**

**Flags:**
- `--business-logic`: Extract complex business operations
- `--external-apis`: Create services for external API integrations
- `--data-processing`: Extract data processing and transformation logic
- `--notifications`: Create notification and communication services
- `--generate-interfaces`: Create interfaces for service contracts

1. **Service Class Architecture Analysis**
   ```markdown
   ## Service Layer Assessment
   
   ### Business Logic Identification
   - **Controller Fat Methods**: Methods exceeding 30 lines with business logic
   - **Model Overloading**: Models with non-database-related methods
   - **External Integrations**: API calls and third-party service interactions
   - **Complex Calculations**: Mathematical operations and data transformations
   - **Workflow Management**: Multi-step processes and state management
   
   ### Service Layer Benefits
   - **Single Responsibility**: Each service handles one business domain
   - **Testability**: Business logic isolated for unit testing
   - **Reusability**: Services can be used across multiple controllers
   - **Maintainability**: Changes centralized in dedicated classes
   - **Dependency Management**: Clear separation of concerns
   ```

2. **Business Logic Service Extraction**
   ```markdown
   ## Domain Service Creation
   
   ### User Management Service
   #### Before: Controller with Business Logic
   ```php
   class UserController extends Controller
   {
       public function register(Request $request)
       {
           // Validation logic
           $validated = $request->validate([...]);
           
           // Business logic mixed in controller
           $user = User::create($validated);
           $user->assignRole('user');
           
           // Send welcome email
           Mail::to($user)->send(new WelcomeEmail($user));
           
           // Create user profile
           $user->profile()->create([
               'display_name' => $user->name,
               'avatar' => 'default.png',
           ]);
           
           // Log user registration
           Log::info('User registered', ['user_id' => $user->id]);
           
           return response()->json($user, 201);
       }
   }
   ```
   
   #### After: Extracted Service Class
   ```php
   <?php
   
   namespace App\Services\User;
   
   use App\Models\User;
   use App\Mail\WelcomeEmail;
   use Illuminate\Support\Facades\DB;
   use Illuminate\Support\Facades\Log;
   use Illuminate\Support\Facades\Mail;
   
   class UserRegistrationService
   {
       public function __construct(
           private UserProfileService $profileService,
           private NotificationService $notificationService,
           private AuditLogService $auditService
       ) {}
   
       public function registerUser(array $userData): User
       {
           return DB::transaction(function () use ($userData) {
               $user = $this->createUser($userData);
               $this->assignDefaultRole($user);
               $this->createUserProfile($user);
               $this->sendWelcomeNotification($user);
               $this->logRegistration($user);
               
               return $user;
           });
       }
   
       private function createUser(array $userData): User
       {
           return User::create([
               'name' => $userData['name'],
               'email' => $userData['email'],
               'password' => bcrypt($userData['password']),
               'email_verified_at' => null,
           ]);
       }
   
       private function assignDefaultRole(User $user): void
       {
           $user->assignRole('user');
       }
   
       private function createUserProfile(User $user): void
       {
           $this->profileService->createDefaultProfile($user);
       }
   
       private function sendWelcomeNotification(User $user): void
       {
           $this->notificationService->sendWelcomeEmail($user);
       }
   
       private function logRegistration(User $user): void
       {
           $this->auditService->logUserAction('registration', $user);
       }
   }
   ```
   
   #### Simplified Controller
   ```php
   class UserController extends Controller
   {
       public function __construct(
           private UserRegistrationService $registrationService
       ) {}
   
       public function register(RegisterUserRequest $request)
       {
           $user = $this->registrationService->registerUser(
               $request->validated()
           );
   
           return new UserResource($user);
       }
   }
   ```
   ```

3. **External API Integration Services**
   ```markdown
   ## External Service Integration
   
   ### Payment Processing Service
   #### Service Implementation
   ```php
   <?php
   
   namespace App\Services\Payment;
   
   use App\Models\Order;
   use App\Models\Payment;
   use App\Exceptions\PaymentFailedException;
   use Illuminate\Support\Facades\Http;
   use Illuminate\Support\Facades\Log;
   
   class PaymentProcessingService
   {
       public function __construct(
           private string $apiKey,
           private string $apiUrl,
           private PaymentLogService $logService
       ) {
           $this->apiKey = config('services.payment.api_key');
           $this->apiUrl = config('services.payment.api_url');
       }
   
       public function processPayment(Order $order, array $paymentData): Payment
       {
           $this->logService->logAttempt($order, $paymentData);
   
           try {
               $response = $this->makePaymentRequest($order, $paymentData);
               $payment = $this->createPaymentRecord($order, $response);
               
               $this->logService->logSuccess($payment);
               
               return $payment;
           } catch (Exception $e) {
               $this->logService->logFailure($order, $e);
               throw new PaymentFailedException(
                   'Payment processing failed: ' . $e->getMessage()
               );
           }
       }
   
       private function makePaymentRequest(Order $order, array $paymentData): array
       {
           $response = Http::withHeaders([
               'Authorization' => 'Bearer ' . $this->apiKey,
               'Content-Type' => 'application/json',
           ])->timeout(30)->post($this->apiUrl . '/charges', [
               'amount' => $order->total_cents,
               'currency' => $order->currency,
               'source' => $paymentData['token'],
               'description' => "Order #{$order->id}",
               'metadata' => [
                   'order_id' => $order->id,
                   'user_id' => $order->user_id,
               ],
           ]);
   
           if (!$response->successful()) {
               throw new Exception('Payment API request failed');
           }
   
           return $response->json();
       }
   
       private function createPaymentRecord(Order $order, array $response): Payment
       {
           return Payment::create([
               'order_id' => $order->id,
               'payment_method' => 'card',
               'amount' => $order->total,
               'currency' => $order->currency,
               'status' => 'completed',
               'transaction_id' => $response['id'],
               'gateway_response' => $response,
           ]);
       }
   }
   ```
   
   ### Service Interface Contract
   ```php
   <?php
   
   namespace App\Contracts\Services;
   
   use App\Models\Order;
   use App\Models\Payment;
   
   interface PaymentServiceInterface
   {
       public function processPayment(Order $order, array $paymentData): Payment;
       
       public function refundPayment(Payment $payment, ?float $amount = null): bool;
       
       public function getPaymentStatus(string $transactionId): string;
   }
   ```
   ```

4. **Data Processing and Transformation Services**
   ```markdown
   ## Data Processing Services
   
   ### Report Generation Service
   #### Complex Data Processing
   ```php
   <?php
   
   namespace App\Services\Reports;
   
   use App\Models\Order;
   use App\Models\User;
   use Carbon\Carbon;
   use Illuminate\Support\Collection;
   
   class SalesReportService
   {
       public function __construct(
           private OrderAnalyticsService $analyticsService,
           private ReportCacheService $cacheService,
           private ExportService $exportService
       ) {}
   
       public function generateMonthlySalesReport(
           Carbon $month,
           array $filters = []
       ): array {
           $cacheKey = $this->buildCacheKey($month, $filters);
           
           return $this->cacheService->remember($cacheKey, 3600, function () use ($month, $filters) {
               $orders = $this->getOrdersForMonth($month, $filters);
               
               return [
                   'summary' => $this->generateSummary($orders),
                   'daily_breakdown' => $this->generateDailyBreakdown($orders, $month),
                   'product_performance' => $this->generateProductPerformance($orders),
                   'customer_segments' => $this->generateCustomerSegments($orders),
                   'trends' => $this->generateTrends($orders),
               ];
           });
       }
   
       private function getOrdersForMonth(Carbon $month, array $filters): Collection
       {
           $query = Order::whereMonth('created_at', $month->month)
                         ->whereYear('created_at', $month->year)
                         ->with(['items.product', 'user']);
   
           if (isset($filters['status'])) {
               $query->where('status', $filters['status']);
           }
   
           if (isset($filters['user_type'])) {
               $query->whereHas('user', function ($q) use ($filters) {
                   $q->where('type', $filters['user_type']);
               });
           }
   
           return $query->get();
       }
   
       private function generateSummary(Collection $orders): array
       {
           return [
               'total_orders' => $orders->count(),
               'total_revenue' => $orders->sum('total'),
               'average_order_value' => $orders->avg('total'),
               'unique_customers' => $orders->pluck('user_id')->unique()->count(),
               'completion_rate' => $this->calculateCompletionRate($orders),
           ];
       }
   
       private function generateDailyBreakdown(Collection $orders, Carbon $month): array
       {
           return $orders->groupBy(function ($order) {
               return $order->created_at->format('Y-m-d');
           })->map(function ($dayOrders) {
               return [
                   'orders' => $dayOrders->count(),
                   'revenue' => $dayOrders->sum('total'),
                   'avg_order_value' => $dayOrders->avg('total'),
               ];
           })->toArray();
       }
   
       public function exportReport(array $reportData, string $format = 'pdf'): string
       {
           return $this->exportService->export($reportData, $format);
       }
   }
   ```
   ```

5. **Notification and Communication Services**
   ```markdown
   ## Communication Service Layer
   
   ### Multi-Channel Notification Service
   #### Notification Orchestration
   ```php
   <?php
   
   namespace App\Services\Notification;
   
   use App\Models\User;
   use App\Models\Notification;
   use App\Mail\OrderConfirmation;
   use App\Events\NotificationSent;
   use Illuminate\Support\Facades\Mail;
   
   class NotificationService
   {
       public function __construct(
           private EmailService $emailService,
           private SmsService $smsService,
           private PushNotificationService $pushService,
           private DatabaseNotificationService $databaseService
       ) {}
   
       public function sendOrderConfirmation(User $user, Order $order): void
       {
           $this->sendMultiChannelNotification($user, [
               'type' => 'order_confirmation',
               'title' => 'Order Confirmed',
               'message' => "Your order #{$order->id} has been confirmed.",
               'data' => [
                   'order_id' => $order->id,
                   'total' => $order->total,
               ],
           ]);
       }
   
       public function sendMultiChannelNotification(User $user, array $notification): void
       {
           $preferences = $user->notification_preferences;
           
           // Always save to database
           $dbNotification = $this->databaseService->create($user, $notification);
           
           // Send email if enabled
           if ($preferences['email'] ?? true) {
               $this->emailService->send($user, $notification);
           }
           
           // Send SMS if enabled and phone number available
           if (($preferences['sms'] ?? false) && $user->phone) {
               $this->smsService->send($user, $notification);
           }
           
           // Send push notification if enabled
           if ($preferences['push'] ?? true) {
               $this->pushService->send($user, $notification);
           }
           
           event(new NotificationSent($user, $dbNotification));
       }
   
       public function markAsRead(User $user, int $notificationId): bool
       {
           return $this->databaseService->markAsRead($user, $notificationId);
       }
   
       public function getUnreadCount(User $user): int
       {
           return $this->databaseService->getUnreadCount($user);
       }
   }
   ```
   
   ### Email Service Implementation
   ```php
   <?php
   
   namespace App\Services\Notification;
   
   use App\Models\User;
   use App\Mail\GenericNotificationMail;
   use Illuminate\Support\Facades\Mail;
   use Illuminate\Support\Facades\Log;
   
   class EmailService
   {
       public function send(User $user, array $notification): bool
       {
           try {
               Mail::to($user->email)->send(
                   new GenericNotificationMail($notification)
               );
               
               Log::info('Email notification sent', [
                   'user_id' => $user->id,
                   'type' => $notification['type'],
               ]);
               
               return true;
           } catch (Exception $e) {
               Log::error('Email notification failed', [
                   'user_id' => $user->id,
                   'error' => $e->getMessage(),
               ]);
               
               return false;
           }
       }
   }
   ```
   ```

6. **Service Provider Registration and Binding**
   ```markdown
   ## Dependency Injection Setup
   
   ### Service Provider Configuration
   #### Custom Service Provider
   ```php
   <?php
   
   namespace App\Providers;
   
   use Illuminate\Support\ServiceProvider;
   use App\Services\User\UserRegistrationService;
   use App\Services\Payment\PaymentProcessingService;
   use App\Services\Notification\NotificationService;
   use App\Contracts\Services\PaymentServiceInterface;
   
   class BusinessServiceProvider extends ServiceProvider
   {
       public function register(): void
       {
           // Bind service interfaces
           $this->app->bind(
               PaymentServiceInterface::class,
               PaymentProcessingService::class
           );
           
           // Singleton services
           $this->app->singleton(NotificationService::class);
           $this->app->singleton(UserRegistrationService::class);
           
           // Service with configuration
           $this->app->bind(PaymentProcessingService::class, function ($app) {
               return new PaymentProcessingService(
                   config('services.payment.api_key'),
                   config('services.payment.api_url'),
                   $app->make(PaymentLogService::class)
               );
           });
       }
   
       public function boot(): void
       {
           //
       }
   }
   ```
   
   ### Service Configuration
   ```php
   // config/services.php
   return [
       'payment' => [
           'api_key' => env('PAYMENT_API_KEY'),
           'api_url' => env('PAYMENT_API_URL', 'https://api.payment-provider.com'),
           'webhook_secret' => env('PAYMENT_WEBHOOK_SECRET'),
       ],
       
       'notification' => [
           'channels' => [
               'email' => env('NOTIFICATION_EMAIL_ENABLED', true),
               'sms' => env('NOTIFICATION_SMS_ENABLED', false),
               'push' => env('NOTIFICATION_PUSH_ENABLED', true),
           ],
           'default_preferences' => [
               'email' => true,
               'sms' => false,
               'push' => true,
           ],
       ],
   ];
   ```
   ```

7. **Service Testing Strategies**
   ```markdown
   ## Service Layer Testing
   
   ### Unit Testing Services
   #### Service Test Example
   ```php
   <?php
   
   namespace Tests\Unit\Services;
   
   use Tests\TestCase;
   use App\Models\User;
   use App\Models\Order;
   use App\Services\User\UserRegistrationService;
   use App\Services\Notification\NotificationService;
   use Mockery;
   
   class UserRegistrationServiceTest extends TestCase
   {
       private UserRegistrationService $service;
       private NotificationService $notificationService;
   
       protected function setUp(): void
       {
           parent::setUp();
           
           $this->notificationService = Mockery::mock(NotificationService::class);
           $this->service = new UserRegistrationService($this->notificationService);
       }
   
       public function test_registers_user_successfully()
       {
           $userData = [
               'name' => 'John Doe',
               'email' => 'john@example.com',
               'password' => 'password123',
           ];
   
           $this->notificationService
               ->shouldReceive('sendWelcomeEmail')
               ->once()
               ->with(Mockery::type(User::class));
   
           $user = $this->service->registerUser($userData);
   
           $this->assertInstanceOf(User::class, $user);
           $this->assertEquals('john@example.com', $user->email);
           $this->assertTrue($user->hasRole('user'));
       }
   
       public function test_handles_registration_failure()
       {
           $userData = [
               'name' => 'John Doe',
               'email' => 'invalid-email',
               'password' => 'short',
           ];
   
           $this->expectException(ValidationException::class);
           
           $this->service->registerUser($userData);
       }
   }
   ```
   
   ### Integration Testing
   ```php
   <?php
   
   namespace Tests\Feature\Services;
   
   use Tests\TestCase;
   use App\Models\Order;
   use App\Services\Payment\PaymentProcessingService;
   use Illuminate\Foundation\Testing\RefreshDatabase;
   use Illuminate\Support\Facades\Http;
   
   class PaymentProcessingServiceTest extends TestCase
   {
       use RefreshDatabase;
   
       public function test_processes_payment_successfully()
       {
           // Mock external API response
           Http::fake([
               'api.payment-provider.com/*' => Http::response([
                   'id' => 'ch_test_123',
                   'status' => 'succeeded',
                   'amount' => 2000,
               ], 200),
           ]);
   
           $order = Order::factory()->create(['total' => 20.00]);
           $paymentData = ['token' => 'tok_test_123'];
   
           $service = app(PaymentProcessingService::class);
           $payment = $service->processPayment($order, $paymentData);
   
           $this->assertEquals('completed', $payment->status);
           $this->assertEquals('ch_test_123', $payment->transaction_id);
           
           Http::assertSent(function ($request) {
               return $request->url() === 'https://api.payment-provider.com/charges';
           });
       }
   }
   ```
   ```

## Usage Examples

```bash
# Extract business logic from specific controller
/laravel-extract-services --business-logic app/Http/Controllers/OrderController.php

# Create services for external API integrations
/laravel-extract-services --external-apis app/Http/Controllers/PaymentController.php

# Extract data processing logic from models
/laravel-extract-services --data-processing app/Models/

# Create notification services
/laravel-extract-services --notifications app/Http/Controllers/

# Generate interfaces for all services
/laravel-extract-services --generate-interfaces app/Services/
```

**Service Extraction Quality Standards:**
- Each service class should have a single responsibility
- Services should be testable in isolation
- Use dependency injection for all service dependencies
- Implement interfaces for service contracts
- Keep controllers thin by delegating to services
- Services should handle their own error management
- Document service APIs and expected behavior