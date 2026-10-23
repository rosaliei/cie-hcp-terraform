# Lesson 03: Option B, handing over the SSH key through a sensitive output

> **Branch:** `03-option-b-sensitive-output` (builds on `02-local-file-drift`)
> **Drawing:** Excalidraw → Gitops → *tf-cloud 03 - option B sensitive output*
> **Tested:** 2026-10-23, `kst-cie/frontend-compute`, Terraform 1.17.0, AWS `1733xxxx6280` / `ap-southeast-1`
> **Compare:** `git diff 02-local-file-drift 03-option-b-sensitive-output -- frontend-compute/`

## The change

`local_file` is gone. The private key is exposed as a **sensitive output** instead, and the operator pulls it to their own machine on demand.

```diff
 # frontend-compute/keypairs.tf
-resource "local_file" "fe_private_key_pem" {
-  content  = tls_private_key.fe_keypair.private_key_pem
-  filename = "${path.module}/${local.fe_private_key_filename}"
-}

 # frontend-compute/outputs.tf
+output "fe_private_key_openssh" {
+  description = "Private SSH key for the frontend instances (OpenSSH format)"
+  value       = tls_private_key.fe_keypair.private_key_openssh
+  sensitive   = true
+}
+
+output "frontend_public_instance01_ip" {
+  value = aws_eip.frontend_public_instance_eip.public_ip
+}
```

- `tls_private_key` and `aws_key_pair` are unchanged, so **the key pair in AWS is not replaced**.
- `private_key_openssh` is used instead of `private_key_pem`, because it's the format `ssh` expects for Ed25519 keys.
- `.gitignore` now also ignores `*.tfplan`, because saved plan files contain sensitive values.

---

## Test, step by step

### ① Saved plan: review before applying ([log](evidence/01-plan.log), run `run-1ctg2wi54cTFr4QR`)
```
$ terraform plan -out=optb.tfplan
local_file.fe_private_key_pem: Refreshing state...   (already gone from state, see lesson 02)
  # aws_instance.frontend_private_instance01..03 must be replaced   ← see ⑦
  # null_resource.configure-fe-* must be replaced                   ← timestamp() trigger
Plan: 5 to add, 0 to change, 5 to destroy.
Changes to Outputs:
  + fe_private_key_openssh         = (sensitive value)
  + frontend_public_instance01_ip  = "47.130.x.x"
```

### ② Apply exactly that plan ([log](evidence/02-apply.log))
```
$ terraform apply optb.tfplan
aws_instance.frontend_private_instance01: Creation complete [id=i-0889af7338e3831b3]
aws_instance.frontend_private_instance02: Creation complete [id=i-02abf027656bfbac2]
aws_instance.frontend_private_instance03: Creation complete [id=i-089c95e8006794c08]
Apply complete! Resources: 5 added, 0 changed, 5 destroyed.

Outputs:
fe_private_key_openssh = (sensitive value)
frontend_public_instance01_ip = "47.130.x.x"
```
HCP also showed a warning, *"No resource schema found for local_file when decoding prior state"*. It's harmless and appears once: the resource was removed from the config but was still in the previous state.

![HCP apply run](screenshots/hcp-apply-run.jpg)

### ③ Retrieve the key and SSH in: it works ([log](evidence/03-retrieve-and-ssh.log))
```
$ terraform output -raw fe_private_key_openssh > frontend-ssh-key.pem
$ chmod 400 frontend-ssh-key.pem
$ ls -la frontend-ssh-key.pem
-r--------  1 k.sithi  staff  387  frontend-ssh-key.pem
$ git check-ignore -v frontend-ssh-key.pem
.gitignore:18:*-ssh-key.pem   frontend-ssh-key.pem        # never committed

$ ssh -i frontend-ssh-key.pem ec2-user@47.130.x.x "hostname; whoami; uptime"
ip-10-0-1-92.ap-southeast-1.compute.internal
ec2-user
```

![Instances still using frontend-ssh-key.pem](screenshots/aws-instances-same-key.png)

### ④ Gotcha: `terraform output NAME` prints the key
```
$ terraform output fe_private_key_openssh      # asking for it BY NAME
<<EOT
-----BEGIN OPENSSH PRIVATE KEY-----
<5 lines of the real private key - REDACTED>
-----END OPENSSH PRIVATE KEY-----
EOT
```
`sensitive = true` hides the value in plan/apply output and in the HCP UI, **but not when you ask for it by name**. This happened during the test itself: the key ended up in a log file (redacted before committing) and in terminal scrollback. Always use `-raw … > file` and never paste the output anywhere.

### ⑤ The key is still in state, in four copies ([log](evidence/04-key-in-state.log), helper: [`keyinstate.py`](keyinstate.py))
```
$ terraform state pull | python3 keyinstate.py     # prints WHERE, never the key
tls_private_key.fe_keypair.private_key_openssh: contains a private key (387 chars, plaintext)
tls_private_key.fe_keypair.private_key_pem: contains a private key (119 chars, plaintext)
tls_private_key.fe_keypair.private_key_pem_pkcs8: contains a private key (119 chars, plaintext)
outputs.fe_private_key_openssh: contains a private key, sensitive=True (still plaintext in state)
```
The HCP UI masks the output, but anyone who can read state or download a state version can SSH into every frontend VM.

![HCP outputs: sensitive](screenshots/hcp-outputs-sensitive.jpg)

### ⑥ Re-plan: the `local_file` drift is gone ([log](evidence/05-replan.log), run `run-Ffb7tD6AqHhdPEKb`)
```
$ terraform plan
  # null_resource.configure-fe-private-instance01 must be replaced   (timestamp)
  # null_resource.configure-fe-public-instance01 must be replaced    (timestamp)
Plan: 2 to add, 0 to change, 2 to destroy.
```
No more `Drift detected`. The only remaining noise is the known `timestamp()` trigger (lesson 01, #11).

![Re-plan: only null_resource](screenshots/hcp-replan-no-drift.jpg)

### ⑦ Side finding: `most_recent = true` rebuilt three servers
```hcl
data "aws_ami" "fe_private_instance_ami" {
  most_recent = true        # Canonical Ubuntu 24.04, newest image
```
```
~ ami = "ami-0080f2c6aa4e378b7" -> "ami-0403d346e3210afd6"  # forces replacement
```
Canonical published a new Ubuntu image between 09:13 and this run. After that, **any** apply replaces all three private instances, whatever the change was about. Lesson 06 covers the fix: pin the AMI ID, or add `lifecycle { ignore_changes = [ami] }` and roll AMIs deliberately.

---

## Verdict

| ✅ Pros | ❌ Cons |
|---|---|
| Works with remote execution: the key reaches the laptop and `ssh` works | **Private key in state** (4 copies), readable by anyone with state access |
| No extra infrastructure | `terraform output NAME` prints it; key files spread across laptops |
| The lesson 02 drift is gone | One key for every VM, no rotation, no audit of who used it |

**Fine for labs, not acceptable for production.**

**Next:**
- `04-option-a-secrets-manager`: a pre-created key in Secrets Manager, read with an `ephemeral` resource, so it's **never in state**
- `05-option-c-ssm-no-keys`: **no SSH key at all**; access through SSM Session Manager
