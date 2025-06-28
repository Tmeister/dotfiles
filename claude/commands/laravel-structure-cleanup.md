# Laravel Structure Cleanup

Organize files according to Laravel conventions, clean up unused routes/controllers/models, implement proper namespace organization, and remove deprecated code patterns.

## Instructions

Clean up and organize Laravel project structure: **$ARGUMENTS**

**Flags:**
- `--routes`: Clean up unused routes and organize route files
- `--controllers`: Remove unused controllers and organize structure
- `--models`: Clean up unused models and optimize organization
- `--views`: Organize and clean up Blade templates
- `--namespaces`: Fix namespace organization and imports

1. **Project Structure Analysis**
   ```markdown
   ## Laravel Structure Assessment
   
   ### Current Structure Evaluation
   - **File Organization**: Check adherence to Laravel conventions
   - **Unused Files**: Identify orphaned controllers, models, views
   - **Namespace Consistency**: Ensure proper PSR-4 compliance
   - **Route Organization**: Analyze route file structure and grouping
   - **Asset Organization**: Review frontend asset structure
   
   ### Laravel Convention Compliance
   - Controllers in `app/Http/Controllers/`
   - Models in `app/Models/`
   - Views in `resources/views/`
   - Routes organized by purpose
   - Middleware properly grouped
   - Service classes in logical directories
   ```

2. **Route Cleanup and Organization**
   ```markdown
   ## Route Structure Optimization
   
   ### Route File Organization
   #### Organized Route Structure
   ```php
   // routes/web.php - Public web routes
   <?php
   
   use App\Http\Controllers\HomeController;
   use App\Http\Controllers\Auth\LoginController;
   use Illuminate\Support\Facades\Route;
   
   // Public routes
   Route::get('/', [HomeController::class, 'index'])->name('home');
   Route::get('/about', [HomeController::class, 'about'])->name('about');
   Route::get('/contact', [HomeController::class, 'contact'])->name('contact');
   
   // Authentication routes
   Route::prefix('auth')->name('auth.')->group(function () {
       Route::get('/login', [LoginController::class, 'showLogin'])->name('login');
       Route::post('/login', [LoginController::class, 'login']);
       Route::post('/logout', [LoginController::class, 'logout'])->name('logout');
   });
   
   // Authenticated routes
   Route::middleware(['auth', 'verified'])->group(function () {
       Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
   });
   ```
   
   ```php
   // routes/admin.php - Admin-specific routes
   <?php
   
   use App\Http\Controllers\Admin\DashboardController;
   use App\Http\Controllers\Admin\UserController;
   use Illuminate\Support\Facades\Route;
   
   Route::middleware(['auth', 'admin'])->prefix('admin')->name('admin.')->group(function () {
       Route::get('/', [DashboardController::class, 'index'])->name('dashboard');
       
       // User management
       Route::resource('users', UserController::class);
       
       // Settings
       Route::prefix('settings')->name('settings.')->group(function () {
           Route::get('/', [SettingsController::class, 'index'])->name('index');
           Route::put('/', [SettingsController::class, 'update'])->name('update');
       });
   });
   ```
   
   ### Unused Route Detection
   ```php
   <?php
   
   namespace App\Console\Commands;
   
   use Illuminate\Console\Command;
   use Illuminate\Support\Facades\Route;
   use Illuminate\Support\Str;
   
   class DetectUnusedRoutesCommand extends Command
   {
       protected $signature = 'routes:unused';
       protected $description = 'Detect potentially unused routes';
   
       public function handle(): void
       {
           $routes = Route::getRoutes();
           $unusedRoutes = [];
           
           foreach ($routes as $route) {
               $name = $route->getName();
               $uri = $route->uri();
               $action = $route->getActionName();
               
               // Skip API and system routes
               if (Str::startsWith($uri, ['api/', '_ignition/'])) {
                   continue;
               }
               
               // Check if route is referenced in code
               if (!$this->isRouteReferenced($name, $uri)) {
                   $unusedRoutes[] = [
                       'name' => $name ?: 'N/A',
                       'uri' => $uri,
                       'action' => $action,
                       'methods' => implode('|', $route->methods()),
                   ];
               }
           }
           
           if (empty($unusedRoutes)) {
               $this->info('No unused routes detected.');
               return;
           }
           
           $this->table(
               ['Name', 'URI', 'Action', 'Methods'],
               $unusedRoutes
           );
           
           $this->warn('Found ' . count($unusedRoutes) . ' potentially unused routes.');
       }
   
       private function isRouteReferenced(string $name, string $uri): bool
       {
           // Search for route references in Blade templates
           $bladeFiles = glob(resource_path('views/**/*.blade.php'));
           
           foreach ($bladeFiles as $file) {
               $content = file_get_contents($file);
               
               // Check for route() helper usage
               if ($name && (
                   str_contains($content, "route('{$name}')") ||
                   str_contains($content, 'route("' . $name . '")')
               )) {
                   return true;
               }
               
               // Check for direct URI references
               if (str_contains($content, $uri)) {
                   return true;
               }
           }
           
           // Search in PHP files
           $phpFiles = glob(app_path('**/*.php'));
           
           foreach ($phpFiles as $file) {
               $content = file_get_contents($file);
               
               if ($name && (
                   str_contains($content, "route('{$name}')") ||
                   str_contains($content, 'route("' . $name . '")')
               )) {
                   return true;
               }
           }
           
           return false;
       }
   }
   ```
   ```

3. **Controller Organization and Cleanup**
   ```markdown
   ## Controller Structure Optimization
   
   ### Controller Directory Organization
   #### Proper Controller Structure
   ```
   app/Http/Controllers/
   ├── Auth/
   │   ├── LoginController.php
   │   ├── RegisterController.php
   │   └── PasswordResetController.php
   ├── Admin/
   │   ├── DashboardController.php
   │   ├── UserController.php
   │   └── SettingsController.php
   ├── Api/
   │   ├── V1/
   │   │   ├── AuthController.php
   │   │   ├── UserController.php
   │   │   └── PostController.php
   │   └── V2/
   │       └── UserController.php
   ├── User/
   │   ├── ProfileController.php
   │   └── PreferencesController.php
   └── Controller.php (Base controller)
   ```
   
   ### Unused Controller Detection
   ```php
   <?php
   
   namespace App\Console\Commands;
   
   use Illuminate\Console\Command;
   use Illuminate\Support\Facades\File;
   use Illuminate\Support\Str;
   
   class DetectUnusedControllersCommand extends Command
   {
       protected $signature = 'controllers:unused';
       protected $description = 'Detect unused controller classes';
   
       public function handle(): void
       {
           $controllerPath = app_path('Http/Controllers');
           $controllers = $this->getAllControllers($controllerPath);
           $unusedControllers = [];
           
           foreach ($controllers as $controller) {
               $className = $this->getClassName($controller);
               
               if (!$this->isControllerUsed($className, $controller)) {
                   $unusedControllers[] = [
                       'class' => $className,
                       'file' => str_replace(app_path(), '', $controller),
                   ];
               }
           }
           
           if (empty($unusedControllers)) {
               $this->info('No unused controllers detected.');
               return;
           }
           
           $this->table(['Class', 'File'], $unusedControllers);
           $this->warn('Found ' . count($unusedControllers) . ' potentially unused controllers.');
           
           if ($this->confirm('Remove unused controllers?')) {
               $this->removeUnusedControllers($unusedControllers);
           }
       }
   
       private function getAllControllers(string $path): array
       {
           return File::allFiles($path);
       }
   
       private function getClassName(string $filePath): string
       {
           $content = file_get_contents($filePath);
           
           if (preg_match('/class\s+(\w+)/', $content, $matches)) {
               return $matches[1];
           }
           
           return basename($filePath, '.php');
       }
   
       private function isControllerUsed(string $className, string $filePath): bool
       {
           // Check routes
           $routeFiles = [
               base_path('routes/web.php'),
               base_path('routes/api.php'),
               base_path('routes/admin.php'),
           ];
           
           foreach ($routeFiles as $routeFile) {
               if (file_exists($routeFile)) {
                   $content = file_get_contents($routeFile);
                   if (str_contains($content, $className)) {
                       return true;
                   }
               }
           }
           
           // Check for controller usage in other files
           $phpFiles = File::allFiles(app_path());
           
           foreach ($phpFiles as $file) {
               if ($file->getPathname() === $filePath) {
                   continue;
               }
               
               $content = file_get_contents($file->getPathname());
               if (str_contains($content, $className)) {
                   return true;
               }
           }
           
           return false;
       }
   }
   ```
   ```

4. **Model Organization and Cleanup**
   ```markdown
   ## Model Structure Optimization
   
   ### Model Directory Organization
   #### Organized Model Structure
   ```
   app/Models/
   ├── User.php
   ├── Post.php
   ├── Comment.php
   ├── Order/
   │   ├── Order.php
   │   ├── OrderItem.php
   │   └── OrderStatus.php
   ├── Product/
   │   ├── Product.php
   │   ├── Category.php
   │   └── Inventory.php
   ├── Support/
   │   ├── Ticket.php
   │   └── TicketReply.php
   └── Traits/
       ├── HasUuid.php
       ├── Searchable.php
       └── SoftDeletes.php
   ```
   
   ### Model Cleanup Service
   ```php
   <?php
   
   namespace App\Services\Cleanup;
   
   use Illuminate\Support\Facades\File;
   use Illuminate\Support\Str;
   
   class ModelCleanupService
   {
       public function findUnusedModels(): array
       {
           $modelPath = app_path('Models');
           $models = File::allFiles($modelPath);
           $unusedModels = [];
           
           foreach ($models as $model) {
               $className = $this->getClassName($model->getPathname());
               
               if (!$this->isModelUsed($className)) {
                   $unusedModels[] = [
                       'class' => $className,
                       'file' => str_replace(app_path(), '', $model->getPathname()),
                   ];
               }
           }
           
           return $unusedModels;
       }
   
       public function findModelsWithoutFactories(): array
       {
           $modelPath = app_path('Models');
           $models = File::allFiles($modelPath);
           $modelsWithoutFactories = [];
           
           foreach ($models as $model) {
               $className = $this->getClassName($model->getPathname());
               
               if (!$this->hasFactory($className)) {
                   $modelsWithoutFactories[] = $className;
               }
           }
           
           return $modelsWithoutFactories;
       }
   
       public function organizeModelsByDomain(): array
       {
           $modelPath = app_path('Models');
           $models = File::allFiles($modelPath);
           $suggestions = [];
           
           foreach ($models as $model) {
               $className = $this->getClassName($model->getPathname());
               $suggestedPath = $this->suggestModelPath($className);
               
               if ($suggestedPath !== $model->getPathname()) {
                   $suggestions[] = [
                       'current' => str_replace(app_path(), '', $model->getPathname()),
                       'suggested' => str_replace(app_path(), '', $suggestedPath),
                   ];
               }
           }
           
           return $suggestions;
       }
   
       private function isModelUsed(string $className): bool
       {
           // Check migrations
           $migrationPath = database_path('migrations');
           $migrations = File::allFiles($migrationPath);
           
           foreach ($migrations as $migration) {
               $content = file_get_contents($migration->getPathname());
               if (str_contains($content, $className)) {
                   return true;
               }
           }
           
           // Check controllers
           $controllerPath = app_path('Http/Controllers');
           $controllers = File::allFiles($controllerPath);
           
           foreach ($controllers as $controller) {
               $content = file_get_contents($controller->getPathname());
               if (str_contains($content, $className)) {
                   return true;
               }
           }
           
           // Check other models for relationships
           $modelPath = app_path('Models');
           $models = File::allFiles($modelPath);
           
           foreach ($models as $model) {
               $content = file_get_contents($model->getPathname());
               if (str_contains($content, $className)) {
                   return true;
               }
           }
           
           return false;
       }
   
       private function suggestModelPath(string $className): string
       {
           $basePath = app_path('Models');
           
           // Suggest organization by domain
           $domains = [
               'Order' => ['Order', 'OrderItem', 'OrderStatus'],
               'Product' => ['Product', 'Category', 'Inventory'],
               'User' => ['User', 'Profile', 'Permission', 'Role'],
               'Support' => ['Ticket', 'TicketReply', 'SupportAgent'],
           ];
           
           foreach ($domains as $domain => $models) {
               if (in_array($className, $models)) {
                   return $basePath . '/' . $domain . '/' . $className . '.php';
               }
           }
           
           return $basePath . '/' . $className . '.php';
       }
   }
   ```
   ```

5. **View Organization and Cleanup**
   ```markdown
   ## Blade Template Organization
   
   ### View Directory Structure
   #### Organized View Structure
   ```
   resources/views/
   ├── layouts/
   │   ├── app.blade.php
   │   ├── admin.blade.php
   │   └── guest.blade.php
   ├── components/
   │   ├── button.blade.php
   │   ├── form/
   │   │   ├── input.blade.php
   │   │   └── select.blade.php
   │   └── card.blade.php
   ├── auth/
   │   ├── login.blade.php
   │   ├── register.blade.php
   │   └── passwords/
   │       └── reset.blade.php
   ├── admin/
   │   ├── dashboard.blade.php
   │   └── users/
   │       ├── index.blade.php
   │       └── show.blade.php
   ├── user/
   │   ├── profile.blade.php
   │   └── settings.blade.php
   └── emails/
       ├── welcome.blade.php
       └── order-confirmation.blade.php
   ```
   
   ### View Cleanup Service
   ```php
   <?php
   
   namespace App\Services\Cleanup;
   
   use Illuminate\Support\Facades\File;
   use Illuminate\Support\Str;
   
   class ViewCleanupService
   {
       public function findUnusedViews(): array
       {
           $viewPath = resource_path('views');
           $views = File::allFiles($viewPath);
           $unusedViews = [];
           
           foreach ($views as $view) {
               $viewName = $this->getViewName($view->getPathname());
               
               if (!$this->isViewUsed($viewName)) {
                   $unusedViews[] = [
                       'name' => $viewName,
                       'file' => str_replace(resource_path(), '', $view->getPathname()),
                   ];
               }
           }
           
           return $unusedViews;
       }
   
       public function findViewsWithoutComponents(): array
       {
           $viewPath = resource_path('views');
           $views = File::allFiles($viewPath);
           $viewsNeedingComponents = [];
           
           foreach ($views as $view) {
               $content = file_get_contents($view->getPathname());
               
               // Look for repetitive HTML that could be componentized
               if ($this->hasRepetitiveElements($content)) {
                   $viewsNeedingComponents[] = [
                       'file' => str_replace(resource_path(), '', $view->getPathname()),
                       'suggestions' => $this->suggestComponents($content),
                   ];
               }
           }
           
           return $viewsNeedingComponents;
       }
   
       private function getViewName(string $filePath): string
       {
           $viewPath = resource_path('views');
           $relativePath = str_replace($viewPath . '/', '', $filePath);
           $viewName = str_replace(['/', '.blade.php'], ['.', ''], $relativePath);
           
           return $viewName;
       }
   
       private function isViewUsed(string $viewName): bool
       {
           // Check controllers
           $controllerPath = app_path('Http/Controllers');
           $controllers = File::allFiles($controllerPath);
           
           foreach ($controllers as $controller) {
               $content = file_get_contents($controller->getPathname());
               
               if (str_contains($content, "'{$viewName}'") || 
                   str_contains($content, "\"{$viewName}\"")) {
                   return true;
               }
           }
           
           // Check other views for includes/extends
           $viewPath = resource_path('views');
           $views = File::allFiles($viewPath);
           
           foreach ($views as $view) {
               $content = file_get_contents($view->getPathname());
               
               if (str_contains($content, "@include('{$viewName}')") ||
                   str_contains($content, "@extends('{$viewName}')")) {
                   return true;
               }
           }
           
           return false;
       }
   
       private function hasRepetitiveElements(string $content): bool
       {
           // Simple heuristic: look for repeated form patterns
           $patterns = [
               '/<form[^>]*>.*?<\/form>/s',
               '/<div class="[^"]*card[^"]*">.*?<\/div>/s',
               '/<button[^>]*>.*?<\/button>/s',
           ];
           
           foreach ($patterns as $pattern) {
               if (preg_match_all($pattern, $content, $matches) > 2) {
                   return true;
               }
           }
           
           return false;
       }
   }
   ```
   ```

6. **Namespace and Import Organization**
   ```markdown
   ## Namespace Cleanup and Organization
   
   ### Namespace Optimization Service
   ```php
   <?php
   
   namespace App\Services\Cleanup;
   
   use Illuminate\Support\Facades\File;
   
   class NamespaceCleanupService
   {
       public function findIncorrectNamespaces(): array
       {
           $appPath = app_path();
           $files = File::allFiles($appPath);
           $incorrectNamespaces = [];
           
           foreach ($files as $file) {
               $expectedNamespace = $this->getExpectedNamespace($file->getPathname());
               $actualNamespace = $this->getActualNamespace($file->getPathname());
               
               if ($expectedNamespace !== $actualNamespace) {
                   $incorrectNamespaces[] = [
                       'file' => str_replace(app_path(), '', $file->getPathname()),
                       'expected' => $expectedNamespace,
                       'actual' => $actualNamespace,
                   ];
               }
           }
           
           return $incorrectNamespaces;
       }
   
       public function findUnusedImports(): array
       {
           $appPath = app_path();
           $files = File::allFiles($appPath);
           $unusedImports = [];
           
           foreach ($files as $file) {
               $content = file_get_contents($file->getPathname());
               $imports = $this->extractImports($content);
               $unused = $this->findUnusedImportsInFile($content, $imports);
               
               if (!empty($unused)) {
                   $unusedImports[] = [
                       'file' => str_replace(app_path(), '', $file->getPathname()),
                       'unused_imports' => $unused,
                   ];
               }
           }
           
           return $unusedImports;
       }
   
       public function optimizeImports(string $filePath): string
       {
           $content = file_get_contents($filePath);
           $imports = $this->extractImports($content);
           
           // Remove unused imports
           $usedImports = array_filter($imports, function($import) use ($content) {
               $className = $this->getClassNameFromImport($import);
               return str_contains($content, $className);
           });
           
           // Sort imports alphabetically
           sort($usedImports);
           
           // Rebuild file content with optimized imports
           return $this->rebuildFileWithImports($content, $usedImports);
       }
   
       private function getExpectedNamespace(string $filePath): string
       {
           $appPath = app_path();
           $relativePath = str_replace($appPath . '/', '', dirname($filePath));
           
           if ($relativePath === '.') {
               return 'App';
           }
           
           return 'App\\' . str_replace('/', '\\', $relativePath);
       }
   
       private function getActualNamespace(string $filePath): string
       {
           $content = file_get_contents($filePath);
           
           if (preg_match('/namespace\s+([^;]+);/', $content, $matches)) {
               return $matches[1];
           }
           
           return '';
       }
   
       private function extractImports(string $content): array
       {
           preg_match_all('/use\s+([^;]+);/', $content, $matches);
           return $matches[1] ?? [];
       }
   
       private function findUnusedImportsInFile(string $content, array $imports): array
       {
           $unused = [];
           
           foreach ($imports as $import) {
               $className = $this->getClassNameFromImport($import);
               
               // Check if class is used in the file
               if (!str_contains($content, $className)) {
                   $unused[] = $import;
               }
           }
           
           return $unused;
       }
   
       private function getClassNameFromImport(string $import): string
       {
           $parts = explode('\\', $import);
           return end($parts);
       }
   }
   ```
   ```

## Usage Examples

```bash
# Clean up unused routes
/laravel-structure-cleanup --routes

# Remove unused controllers
/laravel-structure-cleanup --controllers

# Clean up and organize models
/laravel-structure-cleanup --models

# Organize Blade templates
/laravel-structure-cleanup --views

# Fix namespace organization
/laravel-structure-cleanup --namespaces
```

**Structure Cleanup Quality Standards:**
- All files should follow Laravel naming conventions
- Unused routes, controllers, and models should be removed
- Namespaces should follow PSR-4 standards
- Views should be organized by feature/domain
- Components should be extracted for reusable elements
- Imports should be optimized and sorted
- Directory structure should reflect application architecture
- Dead code should be eliminated systematically