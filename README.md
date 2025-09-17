# AWS Cloud Penetration Test: IAM Privilege Escalation with Pacu

This project is a simulated cloud penetration test focused on identifying and exploiting AWS IAM misconfigurations. Using the open-source exploitation framework Pacu, I successfully identified and mapped multiple privilege escalation paths stemming from a single, overly permissive IAM policy.

The exercise models a real-world scenario where an attacker with initial, limited access can leverage a common security oversight to achieve full account takeover.

---
## Methodology: Mapping Escalation Paths

The attack methodology assumes an attacker has compromised the credentials of an IAM user. The goal is to escalate privileges by abusing existing permissions. The open-source tool **Pacu** automates the discovery of these escalation paths by scanning the target user's permissions and comparing them against a database of known exploitation techniques. The diagram below illustrates this workflow.

<img src="./assets/Network Diagram.jpg" width="800" alt="Diagram of Pacu IAM Privilege Escalation Paths">
*<p align="center">Figure 1: The attack workflow, from initial scan to privilege escalation.</p>*

---
## Execution: Exploitation with Pacu

The penetration test was conducted in a controlled AWS environment containing a deliberately misconfigured IAM user.

### The Vulnerability: Unrestricted IAM Policy
The core of the vulnerability is an inline IAM policy attached to a user, granting unrestricted permissions. The `Effect: "Allow"` combined with `Action: "*"` and `Resource: "*"` is the most dangerous possible configuration, as it effectively gives the user the power to perform any action on any resource within the AWS account, including modifying their own permissions.

<img src="./assets/Vulnerable IAM policy.jpg" width="800" alt="Screenshot of the vulnerable IAM policy in the AWS Console">
*<p align="center">Figure 2: The misconfigured inline policy granting god-mode permissions.</p>*

### The Scan: Identifying Escalation Vectors
With the credentials for the vulnerable user, I ran Pacu's `iam__privesc_scan` module. This automated scan immediately enumerated the user's permissions and **confirmed over 20 distinct privilege escalation methods**. The tool highlighted critical vectors such as `AttachUserPolicy`, `CreateAccessKey`, and `PassRole`, providing a clear roadmap for an attacker to gain administrative access.

<img src="./assets/Pacu scan.jpg" width="800" alt="Terminal output from Pacu's iam__privesc_scan module">
*<p align="center">Figure 3: Pacu confirming numerous privilege escalation paths.</p>*

---
## Impact Analysis & Remediation

The impact of this misconfiguration is a complete account compromise. An attacker could leverage the confirmed vectors to:
* **`AttachUserPolicy`**: Attach the `AdministratorAccess` managed policy to their own user.
* **`CreateAccessKey`**: Create new, persistent access keys for any user, including the root user.
* **`PassRole`**: Pass a highly privileged role to an EC2 instance they control, inheriting its permissions.

**Remediation** involves adhering to the **principle of least privilege**. Administrative permissions like `iam:*` should be heavily restricted. Tools like **AWS IAM Access Analyzer** should be used proactively to identify and remediate overly permissive policies before they can be exploited.

---
## 🚀 Skills & Technologies

* **Cloud Penetration Testing:** Simulating real-world attacks against cloud infrastructure.
* **AWS Identity and Access Management (IAM):** Deep understanding of IAM policies, users, roles, and permission boundaries.
* **Privilege Escalation:** Identifying and exploiting misconfigurations to gain elevated permissions.
* **Pacu Framework:** Utilizing offensive security tools to automate cloud exploitation.
* **Threat Modeling & Vulnerability Analysis:** Analyzing IAM configurations for potential security risks and understanding their impact.
