# AWS IAM Privilege Escalation Analysis with Pacu

## 📌 Overview
This project demonstrates the identification and validation of privilege-escalation exposure within AWS Identity and Access Management (IAM) using Pacu, an open-source AWS exploitation framework. The analysis focuses on risks posed by wildcard policies and maps potential blast radius across EC2, Lambda, and S3.

## 🎯 Objectives
- Identify confirmed IAM escalation paths using Pacu’s `iam__privesc_scan`
- Validate the security risks of wildcard (`*`) actions and resources
- Visualize the blast radius of potential escalations to critical AWS services
- Model post-exploitation impact and propose mitigation strategies

## 🧠 Key Findings
- **Confirmed Vectors:** `AttachUserPolicy` (self-elevation) and `PassRole` combined with service create/update (service-based lateral movement).
- **Persistence (not escalation):** `CreateAccessKey` enables long-lived API access outside console MFA.
- **Wildcard Policy Risk:** Unrestricted policies (`"Action":"*"`, `"Resource":"*"`) permit full API access if attached, enabling takeover scenarios.
- **Blast Radius:** Elevated access can impact EC2 instances, Lambda functions, and S3 buckets.

## 🛠️ Tools & Technologies
- **Pacu** (`iam__privesc_scan`) for escalation-path confirmation
- **AWS IAM** for policy and trust analysis
- **Architecture Diagram** to depict vectors and service impact

## 📊 Blast-Radius Diagram
<img width="800" height="590" alt="image" src="https://github.com/user-attachments/assets/38c4ed1a-5d56-419a-85c2-66d5ef25e6c9" />

**Figure 1: AWS IAM Privilege Escalation Paths (Pacu Analysis Diagram)**  
Shows how an IAM principal can escalate via **AttachUserPolicy** and **PassRole**, and maintain access via **CreateAccessKey**; maps potential impact across **EC2**, **Lambda**, and **S3**.

## 🔍 Escalation Path Breakdown
| Technique        | Description                                                                 | Notes |
|------------------|-----------------------------------------------------------------------------|-------|
| AttachUserPolicy | Attach a high-privilege managed/inline policy to self to gain admin rights. | Confirmed in Pacu output. |
| PassRole         | Pass a privileged role to a service (e.g., Lambda) and execute under it.    | Requires `iam:PassRole` **and** service create/update perms. |
| CreateAccessKey  | Generate long-lived API credentials for persistence.                         | Persistence, **not** escalation. |

## 🧪 Validation Workflow
1. **Scan IAM Privileges:** Ran `iam__privesc_scan` in Pacu to enumerate and confirm feasible techniques.
2. **Assess Wildcards:** Reviewed policies with `Action: *` and `Resource: *` for unrestricted access risk.
3. **Model Role Assumption:** Mapped `PassRole` paths to service execution for lateral movement.
4. **Diagram Blast Radius:** Illustrated service-level impact across EC2, Lambda, and S3.

## 📘 Documentation
Findings, the escalation diagram, Pacu console output, and policy JSON are included in the `docs/` folder (Figures 1–3).

## 👨‍💻 Author
**Ritvik Indupuri** — Security engineer focusing on adversary emulation, cloud IAM attack paths, and identity governance.


