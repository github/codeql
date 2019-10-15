from ftplib import FTP

ftp = FTP('ftp.debian.org')
ftp.login()

ftp.cwd('debian')
ftp.retrlines('LIST')

ftp.quit()