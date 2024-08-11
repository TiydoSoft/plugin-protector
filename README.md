# Plugin Protector

`plugin-protector.sh` is a bash script created by TiydoSoft to enhance the security of WordPress plugins. This script helps protect your plugin directories by creating `index.php` files and adding direct access protection to PHP files.

## Features

- **Create `index.php` Files**: Generates `index.php` files in all subdirectories of the specified plugin path. Existing `index.php` files are not overwritten.
- **Add Direct Access Protection**: Inserts protection code into all PHP files within the specified plugin path. The protection code is added after any existing package comment or at the beginning of the file if no package comment is present.

## Installation

To download the script and make it executable, run the following command:

### Using `curl`:
```bash
curl -LO https://raw.githubusercontent.com/TiydoSoft/plugin-protector/main/plugin-protector.sh && chmod +x plugin-protector.sh
```

### Using `wget`:
```bash
wget https://raw.githubusercontent.com/TiydoSoft/plugin-protector/main/plugin-protector.sh && chmod +x plugin-protector.sh
```

## Usage

The script supports the following options:

- `-p <plugin path>`: Specify the path to the plugin directory.
- `-i`: Create `index.php` files in all subdirectories (skips existing files).
- `-d`: Add direct access protection to all PHP files.
- `-h`: Display this help message.

### Examples

- **Create `index.php` Files**:
  ```bash
  ./plugin-protector.sh -p /path/to/your/plugin -i
  ```

- **Add Direct Access Protection**:
  ```bash
  ./plugin-protector.sh -p /path/to/your/plugin -d
  ```

- **Do Both**:
  ```bash
  ./plugin-protector.sh -p /path/to/your/plugin -i -d
  ```

## License

This project is licensed under the GNU General Public License v2.0. See the [LICENSE](LICENSE) file for more details.

## Contributing

If you have suggestions or improvements, please open an issue or submit a pull request on GitHub.

## Contact

For any inquiries or support, please contact TiydoSoft.

---

TiydoSoft — Build your Infinity Dream!

---
