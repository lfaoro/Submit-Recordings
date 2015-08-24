# Remote Session Recordings Auto-Upload

Drag'n'Drop the '*Submit Recordings*' link in your taskbar

Once the remote session has ended, and AFTER every subsequent remote session, you need to open the link for the program to launch.

Opening the link will automatically launch a PowerShell window asking for the case number associated with your recently performed Remote Sessions.

Insert the correct case number

*Submit Recordings* will automatically gather the location of your Remote Session Recordings by reading TeamViewer's configuration.

*Submit Recordings* will check the connection to the shared folder: *"\\gfi.com\dfs\company data\support\support_ts\RS Recordings\AutoUploads"* if you're unable to connect to that folder, it'll prompt you. Once you fix your connection issue just press *Enter* to continue

If there are no Remote Sessions present in the folder you'll get prompted, press *Enter* to exit.

As *Submit Recordings* finds any Remote Session it will automatically upload them to a folder generated based on your case number opening date. i.e.: if you case was opened on July 2015, your Remote Sessions will be uploaded to *\\NetworkShare\2015\07\GFI-150624-348556*

The uploaded recordings are automatically deleted from your machine, a backup option is available, inform your supervisor if you require backups.

Once the upload is complete you'll receive an email message confirming the upload of your files containig case number and path to the files for your reference.

*Submit Recordings* will automatically copy to your Clipboard the full path to the uploaded Remote Session Recordings. You can use this path inside your case notes.


**Advantages of using Submit Recordings:**
- 1-click operation
- no configuration required (Autoconfigured)
- case number validation
- Automatic path creation
- Backup of files before upload (Safety)
- Operations logging
- Share connection verification
- Email confirmation
- Auto Copy/Paste of Sessions location in your Clipboard for easy pasting inside case notes
