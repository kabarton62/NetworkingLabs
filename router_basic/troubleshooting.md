# <img src="https://www.tamusa.edu/brandguide/jpeglogos/tamusa_final_logo_bw1.jpg" width="100" height="50"> Lab Troubleshooting Tips
---
## Vyos: vyos user not found
The boot configuration can fail to run when vyos boots, causing a router to not add the **vyos** user to the system. One solution is to login to the router as the root user and restart the routing service. The example commands assume R1 is throwing an error that user vyos does not exist.

Examine the script **/lib/systemd/system/vyos-router.service**. 

Note the two lines to start and stop vyos router:

  **ExecStart=/usr/libexec/vyos/init/vyos-router start**
  
  **ExecStop=/usr/libexec/vyos/init/vyos-router stop**
  
If we run the command /usr/libexec/vyos/init/vyos-router we see an error that states three possible options: start, stop or restart. In this case, the router is not running so we need to start it.

```
/usr/libexec/vyos/init/vyos-router start
```

Now attempt to login back in and verify that the router is operating.

---
## **Vyos routing service is running but the boot config is not running**
In this situation a user can login as user **vyos** but the expected router configuration is not running. After logging in as user **vyos** inspect the boot config.
```
cat /opt/vyatta/etc/config/config.boot
```
Compare the boot config on the router to what is expected. If they match, then simply reloading the boot config should solve the problem. If they don't match, verify that the commands used to copy the boot config to the router are correct or copy the boot config manually.

After the correct boot config is saved to /opt/vyatta/etc/config/config.boot, reload the config.

```
vyos/vyos:/$ configure
vyos@vyos# load /opt/vyatta/etc/config/config.boot
Loading configuration from '/opt/vyatta/etc/config/config.boot'
Load complete. Use 'commit' to make changes effective.
[edit]
vyos@vyos# commit
Warning: could not set speed/duplex settings: operation not permitted!
Warning: could not set speed/duplex settings: operation not permitted!
[edit]
```

You _may_ then need to restart the routing service.
```
/usr/libexec/vyos/init/vyos-router restart
```
