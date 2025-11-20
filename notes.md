# Some useful tips and tricks

## AWS SSO Login Function

Here is a simple function you can add to your .zshrc file to streamline your
AWS SSO login process.

This function, which we'll call awssso, runs the aws sso login command and
then automatically exports the necessary environment variables
(AWS_PROFILE and AWS_REGION) to your current shell, making it easier to
start using AWS commands immediately.

```bash
# Function to perform AWS SSO login
function awssso() {
    # 1. Run the AWS SSO login command
    # This will open a browser for authentication if not already logged in.
    aws sso login

    # Check if the login was successful (optional but good practice)
    if [ $? -eq 0 ]; then
        echo "? AWS SSO login successful."
    else
        echo "? AWS SSO login failed or was cancelled."
        return 1
    fi

    # 2. Export AWS credentials from the default profile.
    # Replace 'default' with your actual SSO profile name if needed.
    # The 'aws sso login' command will have created temporary credentials
    # under the specified profile in your ~/.aws/config and ~/.aws/credentials.
    
    # 3. Export AWS_PROFILE environment variable
    # This tells subsequent AWS CLI commands which profile to use.
    export AWS_PROFILE="default"
    
    # 4. Set the default region (replace with your primary region)
    # This is often needed for tools and SDKs to work correctly.
    export AWS_REGION="us-east-1" 

    echo "??  Environment variables set:"
    echo "   AWS_PROFILE: ${AWS_PROFILE}"
    echo "   AWS_REGION: ${AWS_REGION}"
}
```

## Multiple Git Accounts on the Same Machine

When working with multiple Git accounts (e.g., personal and work),
use conditional includes in your global `~/.gitconfig` (requires Git
2.13+):

```gitconfig
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```

Then create separate config files:

- `~/.gitconfig-work` with work account settings
- `~/.gitconfig-personal` with personal account settings

Each file should contain at minimum:

```gitconfig
[user]
    name = Your Name
    email = your.email@example.com
```

### Sample .gitconfig with Best Practices (Cross-Platform)

Here's a comprehensive `~/.gitconfig` example with cross-platform
best practices:

```gitconfig
# Core settings
[core]
    # Use autocrlf=input on Unix/Mac, true on Windows
    # This handles line endings cross-platform
    autocrlf = input
    # Default branch name
    init.defaultBranch = main

# User information (override per account)
[user]
    name = Your Name
    email = your.email@example.com

# Conditional includes for multiple accounts
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
[includeIf "gitdir:~/personal/"]
    path = ~/.gitconfig-personal
```
