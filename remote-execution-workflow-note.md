## 🚀 HCP Terraform Remote Execution & Migration Guide

This multi-module infrastructure project is configured to run using **HCP Terraform Remote Workspaces** under the `HelloCloud_learning` organization. Below are the key configuration standards and troubleshooting steps resolved during setup.

---

### 1. Repository Structure Standards
* **Root-Level Modules:** All 6 individual root modules (`backend-compute`, `backend-network`, `backend-security`, `frontend-compute`, `frontend-network`, `frontend-security`) must live directly at the root of the GitHub repository. 
* Avoid nested wrapper folders, as HCP Terraform working directories expect the module path to point directly to the root of its assigned subfolder.

---

### 2. AWS Authentication via Organization Variable Sets
Because HCP Terraform executes plans and applies on **remote cloud runners**, local files (`~/.aws/credentials`) or EC2 instance metadata cannot be accessed. 

* **Solution:** Create an **Organization Variable Set** in HCP Terraform applied to all workspaces with the following **Environment Variables** (marked as *Sensitive*):
  * `AWS_ACCESS_KEY_ID`
  * `AWS_SECRET_ACCESS_KEY`
  * `AWS_DEFAULT_REGION` (e.g., `us-east-1`)

---

### 3. Cross-Workspace State Sharing (`forbidden` Error Fix)
When modules use `data.terraform_remote_state` to reference outputs from other tiers (e.g., `frontend-network` reading `backend-network`), HCP Terraform blocks access by default for security isolation.

* **Error Encountered:** `Error retrieving state: forbidden ... not authorized to read the state of the workspace`
* **Resolution:** 
  1. Open the producer workspace in HCP Terraform (e.g., `backend-network-ws`).
  2. Navigate to **Settings** ➔ **State sharing**.
  3. Authorize the consumer workspace (e.g., `frontend-network-ws`) as a permitted remote state consumer.

---

### 4. Handling Sibling Directories (`../files/`) in Remote Execution
Remote execution runners upload **only the specific module directory** during a run, meaning relative paths pointing to sibling directories outside the module (like `./../files/`) will fail with a `no such file or directory` error.

* **Accepted Architectural Approaches:**
  * **Option A (Cloud-Native `user_data`):** Embed initialization scripts directly inside the `aws_instance` resource using a heredoc (`user_data = <<-EOF ... EOF`), eliminating the need for external file paths and SSH provisioning over private subnets.
  * **Option B (Local Execution Mode):** If utilizing local file provisioners or shared parent folders, switch the workspace execution mode in HCP Terraform settings from *Remote* to *Local* while keeping remote state storage.

---

### 5. Security Group Ingress Rule References
When defining fine-grained security group rules using cross-workspace outputs (such as allowing SSH between security tiers), ensure that exactly one source attribute is specified.

* **Error Encountered:** `Exactly one of these attributes must be configured: [cidr_ipv4, cidr_ipv6, prefix_list_id, referenced_security_group_id]`
* **Resolution:** Ensure `referenced_security_group_id` is explicitly populated using the remote state output rather than left commented out:
  ```hcl
  resource "aws_vpc_security_group_ingress_rule" "be_private_sg02_allow_ssh_from_fe_private_sg02" {
    security_group_id            = aws_security_group.be_private_sg02.id
    referenced_security_group_id = data.terraform_remote_state.frontend_security.outputs.fe_private_sg02_id
    from_port                    = 22
    ip_protocol                  = "tcp"
    to_port                      = 22
  }