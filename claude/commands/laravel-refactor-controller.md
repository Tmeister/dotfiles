# Laravel Controller Refactoring

Extract business logic from controllers to service classes, implement Form Request validation, and apply single responsibility principle following Laravel best practices.

## Instructions

Refactor Laravel controllers to follow best practices: **$ARGUMENTS**

**Flags:**
- `--extract-services`: Focus on extracting business logic to service classes
- `--form-requests`: Convert inline validation to Form Request classes
- `--dry-run`: Show proposed changes without applying them
- `--scope <scope>`: Target scope - `controller`, `method`, `directory`

1. **Controller Analysis and Assessment**
   ```markdown
   ## Controller Complexity Assessment
   
   ### Current State Analysis
   - **Lines of Code**: Identify controllers exceeding 200 lines
   - **Method Complexity**: Find methods with more than 30 lines
   - **Business Logic**: Locate database operations and complex calculations
   - **Validation Patterns**: Identify inline validation rules
   - **Dependency Count**: Count injected dependencies (should be ≤ 5)
   
   ### Fat Controller Indicators
   - Multiple database queries in single method
   - Complex business calculations
   - Email/notification sending logic
   - File processing operations
   - External API integrations
   - Complex conditional logic
   ```

2. **Service Class Extraction Strategy**
   ```markdown
   ## Business Logic Extraction
   
   ### Service Class Creation
   #### Identify Extractable Logic
   - Database operations beyond simple CRUD
   - Complex business calculations and validations
   - External service integrations
   - File processing and uploads
   - Email and notification logic
   - Report generation and data processing
   
   #### Service Class Structure
   ```php
   <?php
   
   namespace App\Services;
   
   use App\Models\User;
   use App\Models\Order;
   use Illuminate\Support\Facades\DB;
   
   class OrderProcessingService
   {
       public function __construct(
           private PaymentService $paymentService,
           private InventoryService $inventoryService,
           private NotificationService $notificationService
       ) {}
   
       public function processOrder(array $orderData): Order
       {
           return DB::transaction(function () use ($orderData) {
               $order = $this->createOrder($orderData);
               $this->reserveInventory($order);
               $this->processPayment($order);
               $this->sendConfirmationEmail($order);
               
               return $order;
           });
       }
   
       private function createOrder(array $data): Order
       {
           // Order creation logic
       }
   
       private function reserveInventory(Order $order): void
       {
           // Inventory reservation logic
       }
   }
   ```
   
   #### Service Provider Registration
   ```php
   // In AppServiceProvider
   public function register(): void
   {
       $this->app->bind(OrderProcessingService::class);
       $this->app->bind(PaymentService::class);
       $this->app->bind(InventoryService::class);
   }
   ```
   ```

3. **Form Request Implementation**
   ```markdown
   ## Validation Extraction
   
   ### Form Request Creation
   #### Convert Inline Validation
   
   **Before (Controller):**
   ```php
   public function store(Request $request)
   {
       $request->validate([
           'name' => 'required|string|max:255',
           'email' => 'required|email|unique:users,email',
           'password' => 'required|string|min:8|confirmed',
           'role' => 'required|in:admin,user,manager',
       ]);
       
       // Controller logic continues...
   }
   ```
   
   **After (Form Request):**
   ```php
   <?php
   
   namespace App\Http\Requests;
   
   use Illuminate\Foundation\Http\FormRequest;
   use Illuminate\Validation\Rules\Password;
   
   class StoreUserRequest extends FormRequest
   {
       public function authorize(): bool
       {
           return $this->user()->can('create-users');
       }
   
       public function rules(): array
       {
           return [
               'name' => ['required', 'string', 'max:255'],
               'email' => ['required', 'email', 'unique:users,email'],
               'password' => ['required', 'string', Password::defaults(), 'confirmed'],
               'role' => ['required', 'in:admin,user,manager'],
           ];
       }
   
       public function messages(): array
       {
           return [
               'email.unique' => 'This email address is already registered.',
               'role.in' => 'The selected role is invalid.',
           ];
       }
   
       public function attributes(): array
       {
           return [
               'email' => 'email address',
           ];
       }
   }
   ```
   
   **Updated Controller:**
   ```php
   public function store(StoreUserRequest $request)
   {
       $user = $this->userService->createUser($request->validated());
       return redirect()->route('users.index')
           ->with('success', 'User created successfully.');
   }
   ```
   ```

4. **Single Responsibility Implementation**
   ```markdown
   ## Controller Responsibility Reduction
   
   ### Refactored Controller Structure
   #### Before: Fat Controller
   ```php
   class OrderController extends Controller
   {
       public function store(Request $request)
       {
           // 50+ lines of validation
           // 30+ lines of business logic
           // 20+ lines of response formatting
           // Multiple concerns mixed together
       }
   }
   ```
   
   #### After: Thin Controller
   ```php
   class OrderController extends Controller
   {
       public function __construct(
           private OrderService $orderService,
           private OrderResourceService $resourceService
       ) {}
   
       public function index(OrderIndexRequest $request)
       {
           $orders = $this->orderService->getPaginatedOrders(
               $request->getFilters(),
               $request->getPerPage()
           );
   
           return $this->resourceService->collection($orders);
       }
   
       public function store(StoreOrderRequest $request)
       {
           $order = $this->orderService->createOrder($request->validated());
           
           return $this->resourceService->created($order);
       }
   
       public function show(Order $order)
       {
           return $this->resourceService->show($order);
       }
   
       public function update(UpdateOrderRequest $request, Order $order)
       {
           $order = $this->orderService->updateOrder($order, $request->validated());
           
           return $this->resourceService->updated($order);
       }
   
       public function destroy(Order $order)
       {
           $this->orderService->deleteOrder($order);
           
           return $this->resourceService->deleted();
       }
   }
   ```
   ```

5. **Dependency Injection Optimization**
   ```markdown
   ## Constructor Injection Best Practices
   
   ### Dependency Management
   #### Interface-Based Injection
   ```php
   <?php
   
   namespace App\Http\Controllers;
   
   use App\Contracts\Services\UserServiceInterface;
   use App\Contracts\Services\NotificationServiceInterface;
   use App\Http\Requests\StoreUserRequest;
   use App\Http\Requests\UpdateUserRequest;
   
   class UserController extends Controller
   {
       public function __construct(
           private UserServiceInterface $userService,
           private NotificationServiceInterface $notificationService
       ) {}
   
       // Controller methods...
   }
   ```
   
   #### Service Provider Binding
   ```php
   // In AppServiceProvider
   public function register(): void
   {
       $this->app->bind(
           UserServiceInterface::class,
           UserService::class
       );
       
       $this->app->bind(
           NotificationServiceInterface::class,
           EmailNotificationService::class
       );
   }
   ```
   ```

6. **Response Formatting and Resource Classes**
   ```markdown
   ## API Response Standardization
   
   ### Resource Class Implementation
   #### API Resource Creation
   ```php
   <?php
   
   namespace App\Http\Resources;
   
   use Illuminate\Http\Request;
   use Illuminate\Http\Resources\Json\JsonResource;
   
   class UserResource extends JsonResource
   {
       public function toArray(Request $request): array
       {
           return [
               'id' => $this->id,
               'name' => $this->name,
               'email' => $this->email,
               'role' => $this->role,
               'created_at' => $this->created_at->toISOString(),
               'updated_at' => $this->updated_at->toISOString(),
               'permissions' => $this->whenLoaded('permissions'),
               'profile' => new ProfileResource($this->whenLoaded('profile')),
           ];
       }
   }
   ```
   
   #### Resource Collection
   ```php
   <?php
   
   namespace App\Http\Resources;
   
   use Illuminate\Http\Resources\Json\ResourceCollection;
   
   class UserCollection extends ResourceCollection
   {
       public function toArray(Request $request): array
       {
           return [
               'data' => $this->collection,
               'meta' => [
                   'total' => $this->total(),
                   'per_page' => $this->perPage(),
                   'current_page' => $this->currentPage(),
               ],
           ];
       }
   }
   ```
   ```

7. **Error Handling and Exception Management**
   ```markdown
   ## Centralized Error Handling
   
   ### Exception Handler Integration
   #### Custom Exception Classes
   ```php
   <?php
   
   namespace App\Exceptions;
   
   use Exception;
   use Illuminate\Http\JsonResponse;
   use Illuminate\Http\Request;
   
   class BusinessLogicException extends Exception
   {
       public function __construct(
           string $message = 'Business logic error occurred',
           int $code = 422,
           Exception $previous = null
       ) {
           parent::__construct($message, $code, $previous);
       }
   
       public function render(Request $request): JsonResponse
       {
           return response()->json([
               'error' => $this->getMessage(),
               'code' => $this->getCode(),
           ], $this->getCode());
       }
   }
   ```
   
   #### Controller Error Handling
   ```php
   public function store(StoreOrderRequest $request)
   {
       try {
           $order = $this->orderService->createOrder($request->validated());
           return new OrderResource($order);
       } catch (InsufficientInventoryException $e) {
           throw new BusinessLogicException('Not enough inventory available');
       } catch (PaymentFailedException $e) {
           throw new BusinessLogicException('Payment processing failed');
       }
   }
   ```
   ```

8. **Testing Strategy for Refactored Controllers**
   ```markdown
   ## Testing Approach
   
   ### Unit Testing Services
   ```php
   <?php
   
   namespace Tests\Unit\Services;
   
   use App\Services\OrderService;
   use App\Models\Order;
   use Tests\TestCase;
   use Mockery;
   
   class OrderServiceTest extends TestCase
   {
       public function test_creates_order_with_valid_data()
       {
           $orderData = [
               'user_id' => 1,
               'items' => [['id' => 1, 'quantity' => 2]],
               'total' => 100.00,
           ];
   
           $service = new OrderService();
           $order = $service->createOrder($orderData);
   
           $this->assertInstanceOf(Order::class, $order);
           $this->assertEquals(100.00, $order->total);
       }
   }
   ```
   
   ### Feature Testing Controllers
   ```php
   <?php
   
   namespace Tests\Feature\Controllers;
   
   use App\Models\User;
   use Tests\TestCase;
   
   class OrderControllerTest extends TestCase
   {
       public function test_authenticated_user_can_create_order()
       {
           $user = User::factory()->create();
           $orderData = [
               'items' => [['id' => 1, 'quantity' => 2]],
               'shipping_address' => '123 Main St',
           ];
   
           $response = $this->actingAs($user)
               ->postJson('/api/orders', $orderData);
   
           $response->assertStatus(201)
               ->assertJsonStructure([
                   'data' => ['id', 'total', 'status', 'created_at'],
               ]);
       }
   }
   ```
   ```

## Usage Examples

```bash
# Refactor specific controller
/laravel-refactor-controller app/Http/Controllers/OrderController.php

# Extract services from all controllers in directory
/laravel-refactor-controller --extract-services app/Http/Controllers/Admin/

# Convert validation to Form Requests
/laravel-refactor-controller --form-requests --scope controller UserController

# Dry run to see proposed changes
/laravel-refactor-controller --dry-run app/Http/Controllers/
```

**Refactoring Quality Standards:**
- Controllers should be under 200 lines
- Methods should be under 30 lines
- Maximum 5 injected dependencies
- Single responsibility per controller
- All validation in Form Request classes
- Business logic in dedicated service classes
- Proper error handling and response formatting