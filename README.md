AWS IAM Privilege Escalation Analysis with Pacu

By: Ritvik Indupuri
Version: 1.0

Overview

This project maps AWS Identity and Access Management (IAM) privilege-escalation exposure using the open-source framework Pacu. From a tester user context, Pacu’s iam__privesc_scan module confirmed feasible techniques; a separate inline-policy review surfaced a wildcard misconfiguration. All claims are backed by the three included artifacts: an escalation-paths diagram, Pacu console output, and a policy JSON screenshot.

Objectives

Identify and confirm IAM escalation techniques with Pacu iam__privesc_scan.

Assess the security risk of wildcard permissions ("Action":"*", "Resource":"*").

Visualize potential blast radius across EC2, Lambda, and S3.

Provide governance-grade mitigations (proposed; not claimed as implemented here).

Key Findings (evidence-backed)

AttachUserPolicy / PutUserPolicy (confirmed): Self-elevation by attaching a high-privilege policy to the user.

PassRole to a service (confirmed): Passing a privileged role to a service (e.g., Lambda) and executing code under that role enables lateral movement to higher permissions.

CreateAccessKey (confirmed, persistence): Generates long-lived credentials for the current user. This is not a privilege-escalation method by itself; it’s a persistence vector.

Wildcard policy risk (observed): An inline/customer-managed policy with "Action":"*" and "Resource":"*" permits unrestricted API use and can enable account takeover if attached.

Artifacts:


<img width="800" height="590" alt="image" src="https://github.com/user-attachments/assets/44361816-6dcf-421e-85ee-2235c53ec5e4" />

Architecture diagram mapping how an IAM user can escalate via AttachUserPolicy, PassRole, and CreateAccessKey; shows potential impact across EC2, Lambda, and S3, plus governance touchpoints.

<img width="800" height="407" alt="image" src="https://github.com/user-attachments/assets/61dc616c-f6e6-4290-8d8b-c1e63f708037" />

Figure 2 — Pacu iam__privesc_scan: Confirmed Escalation Methods
Terminal output from Pacu confirming feasible techniques from the tester context (e.g., AttachUserPolicy/PutUserPolicy, CreateAccessKey persistence, PassRole-to-service paths).


<img width="800" height="429" alt="image" src="https://github.com/user-attachments/assets/26494930-8d88-4523-ac73-d567da36cc44" />

Figure 3 — Inline IAM Policy Showing Wildcards (“Action”: “”, “Resource”: “”)
 Console/JSON view of a policy granting unrestricted actions across all resources; evidences a misconfiguration enabling full API access if attached.

Rename your actual files to match docs/figure-1.png, docs/figure-2.png, docs/figure-3.png, or update the paths above.

Escalation Path Breakdown
Technique	Precise description	Notes
AttachUserPolicy	Attacker attaches a high-privilege managed/inline policy to self (or target user) to gain admin.	Confirmed by Pacu (Figure 2).
PassRole	Attacker passes a privileged role to a service (e.g., Lambda/EC2) and executes code under that role, inheriting its permissions.	Confirmed pattern (Figures 1–2).
CreateAccessKey	Creates new API keys for the current user to maintain persistent access. Not an escalation path on its own.	Confirmed by Pacu (Figure 2).
Validation Workflow (what was actually done)

Enumerate & Confirm: Ran Pacu iam__privesc_scan to enumerate and confirm feasible techniques from the tester context.

Policy Review: Inspected an inline/customer-managed policy with "Action":"*" and "Resource":"*".

Model Impact: Mapped blast radius to EC2, Lambda, and S3 in the escalation diagram.

Document Evidence: Exported Pacu output and policy JSON screenshots and captioned them as Figures 1–3.

Mitigations (proposed controls)

Remove wildcard permissions; scope actions and resources to least privilege.

Restrict iam:PassRole to approved role ARNs and intended services (e.g., iam:PassedToService condition).

Treat iam:CreateAccessKey as exception-only; enforce rotation and periodic review.

Prefer version-controlled customer-managed policies over inline policies; apply permissions boundaries for builder roles.

Tech Stack (evidence-based)

AWS IAM, Pacu (iam__privesc_scan), AWS Management Console, JSON policy analysis

Reproduction (test account only)

Configure Pacu with test credentials and run:

run iam__privesc_scan


Save terminal output and screenshots as evidence. Do not test against production accounts.
