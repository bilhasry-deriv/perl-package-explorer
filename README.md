# Perl Package Explorer

A tool that scans Perl module files (.pm) in a specified directory and generates a JSON mapping of package names to their relative file paths.

## Features

- Recursively scans directories for Perl module files (.pm)
- Maps package names to their relative file paths
- Outputs results in a pretty-printed JSON format
- Handles both Unix and Windows path separators
- Supports custom output file naming

## Requirements

- Perl 5
- cpanm (Perl module installer)

## Installation

1. Install cpanm if you haven't already:
```bash
curl -L https://cpanmin.us | perl - --sudo App::cpanminus
```

2. Install dependencies using cpanfile:
```bash
cpanm --installdeps .
```

## Usage

```bash
./create_package_map.pl --dir=<directory> [--output=<output_file>] [--help]
```

### Options

- `--dir` (required): Directory to scan for Perl modules
- `--output` (optional): Output JSON file name (default: package_map.json)
- `--help`: Show help message

### Examples

Scan modules in the current directory:
```bash
./create_package_map.pl --dir=.
```

Scan modules with custom output file:
```bash
./create_package_map.pl --dir=./lib --output=modules.json
```

## Output Format

The tool generates a JSON file with the following structure:

```json
{
  "Package::Name": "relative/path/to/module.pm",
  "Another::Package": "another/path/module.pm"
}
```

Each key is a Perl package name found in the scanned .pm files, and its value is the relative path from the scanned directory to the module file.

## Notes

- Only processes files with .pm extension
- Paths in the output JSON use forward slashes (/) regardless of the operating system
- The tool will convert absolute paths to relative paths in the output
