# calver-action
## Description
This custom action outputs the "Calendar Versioning" version number based on the provided schema.

## Usage
```yaml
name: My Workflow
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
      
    - name: Generate calver
      uses: okinagar/calver-action@v0.1.0 
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        TZ: 'Asia/Tokyo'
      with:
        target_branch: 'main'
        schema: 'YYYY.MM.DD.MICRO'
```
## Input
### Environment variables
|              | Required            | Default |
|--------------|---------------------|---------|
| GITHUB_TOKEN | :white_check_mark:  |         |
| TZ           | :x:                 | UTC     |

### Arguments
|               | Required | Default          |
|---------------|----------|------------------|
| TARGET_BRANCH | :x:      | main             |
| SCHEMA        | :x:      | YYYY.MM.DD.MICRO |

## Output
version_number: The generated version number.

## About Schema
- YYYY - Full year - 2006, 2016, 2106
- YY - Short year - 6, 16, 106
- 0Y - Zero-padded year - 06, 16, 106
- MM - Short month - 1, 2 ... 11, 12
- 0M - Zero-padded month - 01, 02 ... 11, 12
- WW - Short week (since start of year) - 1, 2, 33, 52
- 0W - Zero-padded week - 01, 02, 33, 52
- DD - Short day - 1, 2 ... 30, 31
- 0D - Zero-padded day - 01, 02 ... 30, 31
- MICRO - Increment (If you use MICRO, schema must end with MICRO.) - 0, 1, 2...

## Reference
https://calver.org/