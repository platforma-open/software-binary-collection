# Adding New Software Package

This template shows how to add a new software package to the collection.

## Directory Structure

```
software/your-package-name/
│   ├── linux-x64/         # Linux x64 binaries
│   │   └── bin/           # Place your binary here
│   ├── linux-aarch64/     # Linux ARM64 binaries
│   │   └── bin/           # Place your binary here
│   ├── macosx-x64/        # macOS x64 binaries
│   │   └── bin/           # Place your binary here
│   ├── macosx-aarch64/    # macOS ARM64 binaries
│   │   └── bin/           # Place your binary here
│   └── windows-x64/       # Windows x64 binaries
│       └── bin/           # Place your binary here
└── package.json           # Package configuration
```

## Steps to Add New Software

1. Create a new directory for your software:
   ```bash
   cp -r template your-package-name
   ```

2. Update `package.json`:
   - Change `name` to `@platforma-open/milaboratories.software-binary-collection.software-{name}`
   - Update `description`
   - Update `cmd` in `block-software.entrypoints.main.binary` to match your binary name
   - Update `roots` paths if your binary structure is different

3. Place your binaries:
   - Put your platform-specific binaries in the corresponding `{platform}/bin/` directories
   - Make sure binaries are executable (`chmod +x` for Unix-like systems)
   - For unsupported platforms, add please a stub bin file

4. Update the catalogue's `package.json`:
   - Add an entry in the `block-software.entrypoints` section:
     ```json
     "block-software": {
       "entrypoints": {
         "your-package-name": {
           "reference": "@platforma-open/milaboratories.software-binary-collection.software-{name}/dist/tengo/software/main.sw.json"
         }
       }
     }
     ```
   - Add a dependency in the `dependencies` section:
     ```json
     "dependencies": {
       "@platforma-open/milaboratories.software-binary-collection.software-{name}": "workspace:*"
     }
     ```
   - Make sure to use the exact package name in both places
   - Use `workspace:*` for the dependency version
   - The reference path should match your package's build output structure

5. Build
   ```bash
   pnpm run build
   ```

## Package.json Template

```json
{
  "name": "@platforma-open/milaboratories.software-binary-collection.software-{name}",
  "version": "1.0.0",
  "description": "Your software description",
  "scripts": {
    "cleanup": "rm -rf ./pkg-*.tgz && rm -rf ./dist/",
    "build": "pl-pkg build --all-platforms",
    "publish": "pl-pkg publish --all-platforms",
    "postbuild": "[ -z \"${CI}\" ] || pnpm run publish"
  },
  "files": [
    "dist/"
  ],
  "block-software": {
    "entrypoints": {
      "main": {
        "binary": {
          "artifact": {
            "registry": "platforma-open",
            "type": "binary",
            "roots": {
              "linux-x64": "./linux-x64",
              "linux-aarch64": "./linux-aarch64",
              "macosx-x64": "./macosx-x64",
              "macosx-aarch64": "./macosx-aarch64",
              "windows-x64": "./windows-x64"
            }
          },
          "cmd": ["{pkg}/bin/your-binary-name"]
        }
      }
    }
  },
  "license": "UNLICENSED",
  "devDependencies": {
    "@platforma-sdk/package-builder": "catalog:"
  }
}
```

## Notes

- All binary files are tracked using Git LFS
- Make sure your binaries are properly named and executable
- The `cmd` in package.json should point to your actual binary name
- Use `catalog:` for `@platforma-sdk/package-builder` dependency
- Binary paths in `roots` should be relative to the package directory