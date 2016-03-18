Project sWave
==================

Team Planet Express

*Members:*
- Austin Foley
- Brian Millar
- Philip Carey


Notes:
======
https://dev.mysql.com/doc/refman/5.7/en/packet-too-large.html

Our changes to mysql configuration are as follows:


max_allowed_packet = 16M

to allow us to upload files up to 16M



innodb_log_file_size

I'm not sure what exact value this was set to but it needs to large as
exceptions are thrown if the file is more than 10% the size of the log
