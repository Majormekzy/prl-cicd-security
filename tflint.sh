#!/bin/bash

# Manual TFLint installation for Windows/Git Bash
#
# # Step 1: Create a tools directory in your user folder
# mkdir -p ~/tools
#
# # Step 2: Download the latest tflint for Windows
# echo "Downloading TFLint..."
# curl -L -o ~/tools/tflint.zip "https://github.com/terraform-linters/tflint/releases/download/v0.58.0/tflint_windows_amd64.zip"
#
# # Step 3: Extract the binary
# cd ~/tools
# unzip -o tflint.zip
# rm tflint.zip
#
# # Step 4: Make it executable
# chmod +x tflint.exe
#
# # Step 5: Add to PATH permanently
# echo "Adding TFLint to PATH permanently..."
#
# # Check if ~/.bashrc exists, create if it doesn't
# if [ ! -f ~/.bashrc ]; then
#     touch ~/.bashrc
#         echo "Created ~/.bashrc file"
#         fi
#
#         # Check if the PATH export already exists to avoid duplicates
#         if ! grep -q 'export PATH="$HOME/tools:$PATH"' ~/.bashrc; then
#             echo 'export PATH="$HOME/tools:$PATH"' >> ~/.bashrc
#                 echo "Added TFLint tools directory to ~/.bashrc"
#                 else
#                     echo "TFLint tools directory already in ~/.bashrc"
#                     fi
#
#                     # Also add to ~/.bash_profile for login shells
#                     if [ ! -f ~/.bash_profile ]; then
#                         touch ~/.bash_profile
#                             echo "Created ~/.bash_profile file"
#                             fi
#
#                             if ! grep -q 'export PATH="$HOME/tools:$PATH"' ~/.bash_profile; then
#                                 echo 'export PATH="$HOME/tools:$PATH"' >> ~/.bash_profile
#                                     echo "Added TFLint tools directory to ~/.bash_profile"
#                                     else
#                                         echo "TFLint tools directory already in ~/.bash_profile"
#                                         fi
#
#                                         # Add to PATH for current session
#                                         export PATH="$HOME/tools:$PATH"
#
#                                         # Reload the current session
#                                         source ~/.bashrc
#
#                                         # Step 6: Verify installation
#                                         echo ""
#                                         echo "TFLint version:"
#                                         tflint --version
#
#                                         echo ""
#                                         echo "✅ TFLint installed successfully and added to PATH permanently!"
#                                         echo "You can now use 'tflint' command from anywhere."
#                                         echo ""
#                                         echo "Next steps:"
#                                         echo "1. Navigate to your project directory: cd ~/code/aws-infra/aws-cicd-security"
#                                         echo "2. Create .tflint.hcl configuration file"
#                                         echo "3. Run 'make lint' to test"
