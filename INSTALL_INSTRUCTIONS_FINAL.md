# ✅ Drupal Installation - FINAL INSTRUCTIONS

## Current Status
- ✓ Database is empty and ready
- ✓ Files are in place
- ✓ Web server is running
- ✓ Installer is accessible

## Installation URL
**http://localhost/core/install.php**

## Step-by-Step Installation

### Step 1: Language Selection
1. Open http://localhost/core/install.php
2. Select "English" from the dropdown
3. Click **"Save and continue"**

### Step 2: Check Requirements
1. Review the checklist - all items should have green checkmarks
2. If anything is red, it will show an error message
3. Click **"Save and continue"**

### Step 3: Database Configuration
Enter these exact values:
- **Database name**: `drupal`
- **Database username**: `drupal`
- **Database password**: `drupal_password`
- **Host**: `mysql`
- **Port**: `3306` (default)

Click **"Save and continue"**

### Step 4: Installation Profile
1. Select **"Standard"** profile (this gives you all modules)
2. Click **"Save and continue"**
3. **WAIT** - it will install the database (may take 1-2 minutes)

### Step 5: Configure Site
Fill in these fields:
- **Site name**: (your choice, e.g., "My Drupal Site")
- **Site email address**: admin@example.com
- **Username**: admin
- **Password**: (create a strong password - REMEMBER THIS!)
- **Email**: admin@example.com
- Keep "Update notifications" checked
- Click **"Save and continue"**

### Step 6: Installation Complete
You should see a success message and automatically redirect to the login page.

## After Installation

### Login to Admin
- URL: http://localhost/user
- Username: `admin`
- Password: (the one you set in Step 5)

### Admin Dashboard
- URL: http://localhost/admin
- Main site: http://localhost/

### Develop Custom Code
- **Modules**: `/web/modules/custom/`
- **Themes**: `/web/themes/custom/`
- **Settings**: `/web/sites/default/settings.php`

## Troubleshooting

### "Still redirects to installer"
- Make sure you completed every single step
- Check that you clicked through all the way to the success message
- Browser cache might be the issue - clear it and refresh

### "Database connection error"
- Verify hostname is exactly: `mysql` (not localhost)
- Verify password is: `drupal_password` (not just `drupal`)
- Check the database credentials in your docker-compose.yml

### "File permission error"
- This is usually automatically fixed by the installer
- Don't worry about it unless it blocks installation

## Database Info (for reference)
- **Host**: mysql
- **Database**: drupal
- **User**: drupal  
- **Password**: drupal_password
- **PhpMyAdmin**: http://localhost:8081

---

**NOTE**: Once you see the login page, the installation is complete and successful!

