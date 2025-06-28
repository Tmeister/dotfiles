# Laravel Request Validation

Convert inline validation to Form Request classes, implement proper validation rules and messages, add authorization methods, and extract validation logic from controllers.

## Instructions

Implement comprehensive request validation using Laravel Form Requests: **$ARGUMENTS**

**Flags:**
- `--form-requests`: Convert inline validation to Form Request classes
- `--custom-rules`: Create custom validation rules for complex logic
- `--authorization`: Implement authorization methods in requests
- `--api-validation`: Optimize validation for API endpoints
- `--error-handling`: Improve validation error handling and responses

1. **Validation Architecture Assessment**
   ```markdown
   ## Validation System Analysis
   
   ### Current Validation Patterns
   - **Inline Validation**: Controllers with $request->validate() calls
   - **Validation Logic**: Complex validation scattered across controllers
   - **Error Handling**: Inconsistent error response formats
   - **Authorization**: Mixed authorization and validation concerns
   - **Reusability**: Duplicate validation rules across endpoints
   
   ### Form Request Benefits
   - **Separation of Concerns**: Validation logic isolated from controllers
   - **Reusability**: Validation rules can be shared and extended
   - **Authorization**: Built-in authorization method integration
   - **Customization**: Custom error messages and attribute names
   - **Testing**: Validation logic can be unit tested independently
   ```

2. **Form Request Class Implementation**
   ```markdown
   ## Comprehensive Form Request Structure
   
   ### Basic Form Request Pattern
   #### User Registration Request
   ```php
   <?php
   
   namespace App\Http\Requests\Auth;
   
   use Illuminate\Foundation\Http\FormRequest;
   use Illuminate\Validation\Rules\Password;
   use Illuminate\Validation\Rule;
   
   class RegisterUserRequest extends FormRequest
   {
       public function authorize(): bool
       {
           // Allow registration for guests only
           return auth()->guest();
       }
   
       public function rules(): array
       {
           return [
               'name' => [
                   'required',
                   'string',
                   'max:255',
                   'regex:/^[a-zA-Z\s]+$/', // Only letters and spaces
               ],
               'email' => [
                   'required',
                   'email:rfc,dns',
                   'max:255',
                   Rule::unique('users', 'email'),
               ],
               'password' => [
                   'required',
                   'string',
                   'confirmed',
                   Password::min(12)
                       ->letters()
                       ->mixedCase()
                       ->numbers()
                       ->symbols()
                       ->uncompromised(),
               ],
               'terms' => [
                   'required',
                   'accepted',
               ],
               'date_of_birth' => [
                   'required',
                   'date',
                   'before:-18 years', // Must be 18+
               ],
           ];
       }
   
       public function messages(): array
       {
           return [
               'name.regex' => 'The name may only contain letters and spaces.',
               'email.unique' => 'This email address is already registered.',
               'password.uncompromised' => 'The password has been compromised in a data breach. Please choose a different password.',
               'date_of_birth.before' => 'You must be at least 18 years old to register.',
           ];
       }
   
       public function attributes(): array
       {
           return [
               'date_of_birth' => 'date of birth',
               'terms' => 'terms and conditions',
           ];
       }
   
       protected function prepareForValidation(): void
       {
           $this->merge([
               'name' => trim($this->name),
               'email' => strtolower(trim($this->email)),
           ]);
       }
   }
   ```
   
   ### Advanced Form Request with Complex Validation
   #### Order Creation Request
   ```php
   <?php
   
   namespace App\Http\Requests\Order;
   
   use App\Models\Product;
   use App\Rules\ValidInventoryQuantity;
   use App\Rules\ValidCouponCode;
   use Illuminate\Foundation\Http\FormRequest;
   use Illuminate\Validation\Rule;
   
   class CreateOrderRequest extends FormRequest
   {
       public function authorize(): bool
       {
           // Must be authenticated and verified
           return auth()->check() && auth()->user()->hasVerifiedEmail();
       }
   
       public function rules(): array
       {
           return [
               'items' => [
                   'required',
                   'array',
                   'min:1',
                   'max:50', // Limit cart size
               ],
               'items.*.product_id' => [
                   'required',
                   'integer',
                   Rule::exists('products', 'id')->where('active', true),
               ],
               'items.*.quantity' => [
                   'required',
                   'integer',
                   'min:1',
                   'max:10',
                   new ValidInventoryQuantity(),
               ],
               'items.*.options' => [
                   'nullable',
                   'array',
               ],
               'shipping_address' => [
                   'required',
                   'array',
               ],
               'shipping_address.street' => [
                   'required',
                   'string',
                   'max:255',
               ],
               'shipping_address.city' => [
                   'required',
                   'string',
                   'max:100',
               ],
               'shipping_address.postal_code' => [
                   'required',
                   'string',
                   'regex:/^\d{5}(-\d{4})?$/', // US ZIP code format
               ],
               'shipping_address.country' => [
                   'required',
                   'string',
                   'size:2', // ISO country code
                   Rule::in(['US', 'CA', 'MX']), // Supported countries
               ],
               'billing_address' => [
                   'nullable',
                   'array',
               ],
               'coupon_code' => [
                   'nullable',
                   'string',
                   'max:50',
                   new ValidCouponCode(),
               ],
               'notes' => [
                   'nullable',
                   'string',
                   'max:1000',
               ],
           ];
       }
   
       public function withValidator($validator): void
       {
           $validator->after(function ($validator) {
               // Custom validation: check total order value
               if ($this->calculateOrderTotal() < 10) {
                   $validator->errors()->add('total', 'Minimum order value is $10.00');
               }
   
               // Validate shipping restrictions
               if (!$this->isShippingAvailable()) {
                   $validator->errors()->add('shipping_address', 'Shipping not available to this location');
               }
           });
       }
   
       private function calculateOrderTotal(): float
       {
           $total = 0;
           foreach ($this->items as $item) {
               $product = Product::find($item['product_id']);
               $total += $product->price * $item['quantity'];
           }
           return $total;
       }
   
       private function isShippingAvailable(): bool
       {
           $address = $this->shipping_address;
           // Custom shipping logic
           return in_array($address['country'], ['US', 'CA']);
       }
   }
   ```
   ```

3. **Custom Validation Rules Implementation**
   ```markdown
   ## Custom Validation Rules
   
   ### Complex Business Logic Validation
   #### Inventory Validation Rule
   ```php
   <?php
   
   namespace App\Rules;
   
   use App\Models\Product;
   use Illuminate\Contracts\Validation\Rule;
   
   class ValidInventoryQuantity implements Rule
   {
       private int $productId;
       private int $requestedQuantity;
   
       public function passes($attribute, $value): bool
       {
           // Extract product_id from the attribute path
           // e.g., items.0.quantity -> items.0.product_id
           $productIdAttribute = str_replace('quantity', 'product_id', $attribute);
           $this->productId = request()->input($productIdAttribute);
           $this->requestedQuantity = $value;
   
           $product = Product::find($this->productId);
           
           if (!$product) {
               return false;
           }
   
           // Check if sufficient inventory
           return $product->inventory_quantity >= $this->requestedQuantity;
       }
   
       public function message(): string
       {
           $product = Product::find($this->productId);
           $available = $product ? $product->inventory_quantity : 0;
           
           return "Only {$available} units available for this product.";
       }
   }
   ```
   
   #### Coupon Code Validation Rule
   ```php
   <?php
   
   namespace App\Rules;
   
   use App\Models\Coupon;
   use Illuminate\Contracts\Validation\Rule;
   use Carbon\Carbon;
   
   class ValidCouponCode implements Rule
   {
       private ?Coupon $coupon = null;
   
       public function passes($attribute, $value): bool
       {
           $this->coupon = Coupon::where('code', $value)
               ->where('active', true)
               ->first();
   
           if (!$this->coupon) {
               return false;
           }
   
           // Check expiration
           if ($this->coupon->expires_at && Carbon::now()->isAfter($this->coupon->expires_at)) {
               return false;
           }
   
           // Check usage limits
           if ($this->coupon->usage_limit && $this->coupon->used_count >= $this->coupon->usage_limit) {
               return false;
           }
   
           // Check user-specific limits
           $userId = auth()->id();
           if ($userId && $this->coupon->user_usage_limit) {
               $userUsage = $this->coupon->orders()
                   ->where('user_id', $userId)
                   ->count();
               
               if ($userUsage >= $this->coupon->user_usage_limit) {
                   return false;
               }
           }
   
           return true;
       }
   
       public function message(): string
       {
           if (!$this->coupon) {
               return 'The coupon code is invalid.';
           }
   
           if ($this->coupon->expires_at && Carbon::now()->isAfter($this->coupon->expires_at)) {
               return 'This coupon has expired.';
           }
   
           return 'This coupon is no longer available.';
       }
   }
   ```
   
   ### Database-Dependent Validation Rule
   ```php
   <?php
   
   namespace App\Rules;
   
   use App\Models\User;
   use Illuminate\Contracts\Validation\Rule;
   
   class UniqueEmailExceptSelf implements Rule
   {
       private int $userId;
   
       public function __construct(int $userId)
       {
           $this->userId = $userId;
       }
   
       public function passes($attribute, $value): bool
       {
           return !User::where('email', $value)
               ->where('id', '!=', $this->userId)
               ->exists();
       }
   
       public function message(): string
       {
           return 'The email address is already taken.';
       }
   }
   
   // Usage in Form Request
   'email' => [
       'required',
       'email',
       new UniqueEmailExceptSelf(auth()->id()),
   ],
   ```
   ```

4. **API Validation and Error Handling**
   ```markdown
   ## API-Specific Validation
   
   ### API Form Request Implementation
   #### JSON API Request Validation
   ```php
   <?php
   
   namespace App\Http\Requests\Api;
   
   use Illuminate\Foundation\Http\FormRequest;
   use Illuminate\Contracts\Validation\Validator;
   use Illuminate\Http\Exceptions\HttpResponseException;
   
   class ApiCreatePostRequest extends FormRequest
   {
       public function authorize(): bool
       {
           return auth('api')->check() && 
                  auth('api')->user()->can('create-posts');
       }
   
       public function rules(): array
       {
           return [
               'title' => [
                   'required',
                   'string',
                   'max:255',
                   'unique:posts,title',
               ],
               'content' => [
                   'required',
                   'string',
                   'min:100',
               ],
               'category_id' => [
                   'required',
                   'integer',
                   'exists:categories,id',
               ],
               'tags' => [
                   'nullable',
                   'array',
                   'max:10',
               ],
               'tags.*' => [
                   'string',
                   'max:50',
               ],
               'published' => [
                   'boolean',
               ],
               'featured_image' => [
                   'nullable',
                   'image',
                   'max:2048', // 2MB
                   'dimensions:min_width=800,min_height=600',
               ],
           ];
       }
   
       protected function failedValidation(Validator $validator): void
       {
           throw new HttpResponseException(
               response()->json([
                   'success' => false,
                   'message' => 'Validation failed',
                   'errors' => $validator->errors(),
                   'error_code' => 'VALIDATION_FAILED',
               ], 422)
           );
       }
   
       protected function failedAuthorization(): void
       {
           throw new HttpResponseException(
               response()->json([
                   'success' => false,
                   'message' => 'Insufficient permissions',
                   'error_code' => 'AUTHORIZATION_FAILED',
               ], 403)
           );
       }
   }
   ```
   
   ### API Error Response Formatting
   ```php
   <?php
   
   namespace App\Http\Requests\Api;
   
   use Illuminate\Foundation\Http\FormRequest;
   
   abstract class BaseApiRequest extends FormRequest
   {
       protected function formatErrors(array $errors): array
       {
           $formatted = [];
           
           foreach ($errors as $field => $messages) {
               $formatted[] = [
                   'field' => $field,
                   'message' => $messages[0], // First error message
                   'code' => $this->getErrorCode($field, $messages[0]),
               ];
           }
           
           return $formatted;
       }
   
       private function getErrorCode(string $field, string $message): string
       {
           if (str_contains($message, 'required')) {
               return 'FIELD_REQUIRED';
           }
           
           if (str_contains($message, 'unique')) {
               return 'FIELD_NOT_UNIQUE';
           }
           
           if (str_contains($message, 'exists')) {
               return 'FIELD_NOT_EXISTS';
           }
           
           return 'FIELD_INVALID';
       }
   
       protected function failedValidation(Validator $validator): void
       {
           throw new HttpResponseException(
               response()->json([
                   'success' => false,
                   'message' => 'Validation failed',
                   'errors' => $this->formatErrors($validator->errors()->toArray()),
                   'timestamp' => now()->toISOString(),
               ], 422)
           );
       }
   }
   ```
   ```

5. **Conditional and Dynamic Validation**
   ```markdown
   ## Advanced Validation Scenarios
   
   ### Conditional Validation Rules
   #### Dynamic Rule Application
   ```php
   <?php
   
   namespace App\Http\Requests;
   
   use Illuminate\Foundation\Http\FormRequest;
   use Illuminate\Validation\Rule;
   
   class UpdateUserProfileRequest extends FormRequest
   {
       public function rules(): array
       {
           $rules = [
               'name' => ['required', 'string', 'max:255'],
               'bio' => ['nullable', 'string', 'max:1000'],
               'avatar' => ['nullable', 'image', 'max:1024'],
           ];
   
           // Conditional email validation
           if ($this->filled('email')) {
               $rules['email'] = [
                   'email',
                   Rule::unique('users', 'email')->ignore(auth()->id()),
               ];
               
               // Require password confirmation if changing email
               $rules['current_password'] = ['required', 'current_password'];
           }
   
           // Role-specific validation
           if (auth()->user()->hasRole('premium')) {
               $rules['website'] = ['nullable', 'url'];
               $rules['social_links'] = ['nullable', 'array', 'max:5'];
               $rules['social_links.*'] = ['url'];
           }
   
           // Age-restricted content
           if ($this->boolean('contains_mature_content')) {
               $rules['age_verification'] = ['required', 'accepted'];
           }
   
           return $rules;
       }
   
       public function withValidator($validator): void
       {
           $validator->after(function ($validator) {
               // Custom validation based on user type
               if (auth()->user()->type === 'business') {
                   if (!$this->filled('company_name')) {
                       $validator->errors()->add('company_name', 'Company name is required for business accounts.');
                   }
               }
   
               // Cross-field validation
               if ($this->filled('birth_date') && $this->filled('age_verification')) {
                   $age = now()->diffInYears($this->birth_date);
                   if ($age < 18) {
                       $validator->errors()->add('age_verification', 'Must be 18+ to enable mature content.');
                   }
               }
           });
       }
   }
   ```
   
   ### Multi-Step Form Validation
   ```php
   <?php
   
   namespace App\Http\Requests;
   
   use Illuminate\Foundation\Http\FormRequest;
   
   class MultiStepFormRequest extends FormRequest
   {
       public function rules(): array
       {
           $step = $this->input('step', 1);
           
           return match($step) {
               1 => $this->stepOneRules(),
               2 => $this->stepTwoRules(),
               3 => $this->stepThreeRules(),
               default => [],
           };
       }
   
       private function stepOneRules(): array
       {
           return [
               'first_name' => ['required', 'string', 'max:255'],
               'last_name' => ['required', 'string', 'max:255'],
               'email' => ['required', 'email', 'unique:users'],
           ];
       }
   
       private function stepTwoRules(): array
       {
           return [
               'company_name' => ['required', 'string', 'max:255'],
               'job_title' => ['required', 'string', 'max:255'],
               'industry' => ['required', 'string', 'in:tech,finance,healthcare,education'],
           ];
       }
   
       private function stepThreeRules(): array
       {
           return [
               'password' => ['required', 'string', 'min:8', 'confirmed'],
               'terms' => ['required', 'accepted'],
               'newsletter' => ['boolean'],
           ];
       }
   }
   ```
   ```

6. **Validation Testing Strategies**
   ```markdown
   ## Form Request Testing
   
   ### Unit Testing Form Requests
   #### Validation Rule Testing
   ```php
   <?php
   
   namespace Tests\Unit\Requests;
   
   use App\Http\Requests\Auth\RegisterUserRequest;
   use Illuminate\Foundation\Testing\RefreshDatabase;
   use Illuminate\Support\Facades\Validator;
   use Tests\TestCase;
   
   class RegisterUserRequestTest extends TestCase
   {
       use RefreshDatabase;
   
       public function test_valid_registration_data_passes_validation()
       {
           $data = [
               'name' => 'John Doe',
               'email' => 'john@example.com',
               'password' => 'SecurePassword123!',
               'password_confirmation' => 'SecurePassword123!',
               'terms' => true,
               'date_of_birth' => '1990-01-01',
           ];
   
           $request = new RegisterUserRequest();
           $validator = Validator::make($data, $request->rules());
   
           $this->assertTrue($validator->passes());
       }
   
       public function test_invalid_email_fails_validation()
       {
           $data = [
               'name' => 'John Doe',
               'email' => 'invalid-email',
               'password' => 'SecurePassword123!',
               'password_confirmation' => 'SecurePassword123!',
               'terms' => true,
               'date_of_birth' => '1990-01-01',
           ];
   
           $request = new RegisterUserRequest();
           $validator = Validator::make($data, $request->rules());
   
           $this->assertFalse($validator->passes());
           $this->assertArrayHasKey('email', $validator->errors()->toArray());
       }
   
       public function test_weak_password_fails_validation()
       {
           $data = [
               'name' => 'John Doe',
               'email' => 'john@example.com',
               'password' => 'weak',
               'password_confirmation' => 'weak',
               'terms' => true,
               'date_of_birth' => '1990-01-01',
           ];
   
           $request = new RegisterUserRequest();
           $validator = Validator::make($data, $request->rules());
   
           $this->assertFalse($validator->passes());
           $this->assertArrayHasKey('password', $validator->errors()->toArray());
       }
   
       public function test_underage_user_fails_validation()
       {
           $data = [
               'name' => 'Young User',
               'email' => 'young@example.com',
               'password' => 'SecurePassword123!',
               'password_confirmation' => 'SecurePassword123!',
               'terms' => true,
               'date_of_birth' => now()->subYears(16)->format('Y-m-d'), // 16 years old
           ];
   
           $request = new RegisterUserRequest();
           $validator = Validator::make($data, $request->rules());
   
           $this->assertFalse($validator->passes());
           $this->assertArrayHasKey('date_of_birth', $validator->errors()->toArray());
       }
   }
   ```
   
   ### Feature Testing with Form Requests
   ```php
   <?php
   
   namespace Tests\Feature\Requests;
   
   use App\Models\User;
   use Illuminate\Foundation\Testing\RefreshDatabase;
   use Tests\TestCase;
   
   class CreateOrderRequestTest extends TestCase
   {
       use RefreshDatabase;
   
       public function test_authenticated_user_can_create_order_with_valid_data()
       {
           $user = User::factory()->verified()->create();
           
           $orderData = [
               'items' => [
                   [
                       'product_id' => Product::factory()->create()->id,
                       'quantity' => 2,
                   ],
               ],
               'shipping_address' => [
                   'street' => '123 Main St',
                   'city' => 'Anytown',
                   'postal_code' => '12345',
                   'country' => 'US',
               ],
           ];
   
           $response = $this->actingAs($user)
               ->postJson('/api/orders', $orderData);
   
           $response->assertStatus(201);
       }
   
       public function test_guest_cannot_create_order()
       {
           $orderData = [
               'items' => [
                   [
                       'product_id' => Product::factory()->create()->id,
                       'quantity' => 1,
                   ],
               ],
           ];
   
           $response = $this->postJson('/api/orders', $orderData);
   
           $response->assertStatus(403);
       }
   }
   ```
   ```

## Usage Examples

```bash
# Convert inline validation to Form Requests
/laravel-validate-requests --form-requests app/Http/Controllers/

# Create custom validation rules
/laravel-validate-requests --custom-rules app/Rules/

# Implement authorization in requests
/laravel-validate-requests --authorization app/Http/Requests/

# Optimize API validation
/laravel-validate-requests --api-validation app/Http/Controllers/Api/

# Improve error handling
/laravel-validate-requests --error-handling
```

**Validation Quality Standards:**
- All controller validation should use Form Request classes
- Custom validation rules should be created for complex business logic
- Authorization should be handled within Form Request classes
- Error messages should be user-friendly and specific
- API responses should have consistent error formatting
- Validation rules should be thoroughly tested
- Security-sensitive validation should use robust patterns