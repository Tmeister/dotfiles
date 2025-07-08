
## ⚠️ EXTREMELY IMPORTANT DEVELOPMENT GUIDELINES

### **Code Quality and Diagnostics**

- **ALWAYS use `mcp_ide_getDiagnostics`** after modifying any file** to check for linting and type errors
- **DO NOT build the app on every step** - only build when specifically testing or deploying
- **Fix any diagnostics issues immediately** before proceeding with additional changes
- **Prioritize code quality** over speed of implementation
- Do not add your signature to the commit messages
- Never use ENUM fields on the database, always use either text or tinyints, but never enums