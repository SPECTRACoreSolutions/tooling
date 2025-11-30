# SPECTRA Identity Infrastructure Audit Report
**Generated:** 2025-11-28  
**Tenant:** spectradatasolutions.com  
**Tenant ID:** 89aaf206-0c55-4dd7-9147-9c95c1a0ff39  
**Purpose:** Enterprise AI Company Identity Infrastructure Assessment

---

## Executive Summary

SPECTRA Data Solutions has a functional Entra ID tenant with solid foundations but requires strategic enhancements to support:
- **UniFi physical/digital identity integration** (Must-have requirement)
- **Multi-device 2FA** (YubiKey, Windows Hello, UniFi FaceID)
- **Premium SSO experience** with GitHub OAuth
- **Custom branding** for identity banner

**Overall Status:** 🟡 **Maturing** - Good foundation, needs strategic tooling and configuration additions

---

## 1. Current Tooling Assessment

### ✅ Installed & Working
| Tool | Version | Status | Authentication |
|------|---------|--------|----------------|
| **Azure CLI** | 2.80.0 | ✅ Active | Service Principal |
| **Microsoft Graph CLI** | 1.9.0 | ⚠️ Not authenticated | Needs login |
| **GitHub CLI** | 2.83.1 | ✅ Authenticated | User: MarkMaconnachie |
| **M365 CLI** | 11.1.0 | ✅ Authenticated | App: spectra-graph-app-admin-prod |
| **Docker** | 28.5.2 | ✅ Active | - |
| **Python** | 3.11.9 | ✅ Active | With msal libs |

### ❌ Missing Critical Tools
| Tool | Priority | Reason |
|------|----------|--------|
| **Terraform** | 🔴 HIGH | IaC for Entra/Conditional Access policies |
| **Azure PowerShell** | 🟡 MEDIUM | Alternative to Azure CLI, better Windows integration |
| **Bicep CLI** | 🟡 MEDIUM | Alternative IaC for Azure resources |
| **Postman/Bruno** | 🟢 LOW | API testing for Graph/UniFi APIs |

### 🔧 Python Packages Present
- `msal` 1.34.0 - Microsoft Authentication Library ✅
- `msal-extensions` 1.3.1 - Token cache helpers ✅
- `ms-fabric-cli` 1.2.0 - Fabric management ✅
- `cryptography` 46.0.3 - Certificate/key handling ✅

---

## 2. Tenant Configuration Audit

### Users & Structure
**Total Users:** 12 (Mix of individuals and functional accounts)

| Type | Count | Examples |
|------|-------|----------|
| Real Users | 6 | mark@, corey@, lyndsey@, jaimie@, tony@, will@ |
| Functional Accounts | 5 | contact@, design@, security@, support@, engagement@ |
| AI Persona | 1 | alana@ (cloud dev environment) |

**Domain:** `spectradatasolutions.com` ✅

### App Registrations (Identity Apps)
| Application | App ID | Purpose | Status |
|------------|--------|---------|--------|
| **spectra-graph-app-admin-prod** | 0d7652ce-6a03-489b-9097-3bbbe8f2486d | Graph API admin access | ✅ Active |
| **spectra-portal-spa-ui-prod** | 3e0aea56-b41b-4c65-811c-23b7d5074761 | Portal UI SPA | ✅ Active |
| **spectra-proxy-api-backend-prod** | ea806d6e-755d-46ce-8027-b89fe0770761 | Backend API proxy | ✅ Active |
| **spectra-fabric-app-admin-prod** | 2cabd8ba-fd56-43c6-8c33-cea62cd5cb49 | Fabric management | ✅ Active |

**Architecture:** Multi-app separation of concerns ✅ **Industry best practice**

### Graph Admin App Permissions
Currently has comprehensive admin permissions:
- ✅ Application.ReadWrite.All
- ✅ Directory.ReadWrite.All
- ✅ User.ReadWrite.All
- ✅ Group.ReadWrite.All
- ✅ RoleManagement.ReadWrite.Directory
- ✅ Policy.Read.All
- ✅ AuditLog.Read.All
- ✅ Reports.Read.All

**Assessment:** Appropriate for tenant administration ✅

---

## 3. Authentication Methods Analysis

### Enabled Methods (Tenant-Wide)
| Method | Status | Target | Passwordless | Risk Level |
|--------|--------|--------|--------------|------------|
| **FIDO2** | ✅ Enabled | All users | Yes | 🟢 Low |
| **Microsoft Authenticator** | ✅ Enabled | All users | Conditional | 🟢 Low |
| **SMS** | ✅ Enabled | All users | No | 🟡 Medium |
| **Voice** | ✅ Enabled | All users | No | 🟡 Medium |
| **Email OTP** | ✅ Enabled | All users | No | 🔴 High |
| **Software OATH** | ✅ Enabled | All users | No | 🟢 Low |
| **Temporary Access Pass** | ✅ Enabled | All users | No | 🟡 Medium |
| **X.509 Certificate** | ❌ Disabled | - | Yes | 🟢 Low |

### Key Findings: Authentication

#### ✅ Strengths
1. **FIDO2 Enabled** - Perfect for YubiKey integration
2. **Microsoft Authenticator** - Supports Windows Hello
3. **Flexible Methods** - Multiple backup options available

#### ⚠️ Concerns
1. **Email OTP Enabled** - Risky for AI company; should be restricted
2. **SMS Enabled** - Vulnerable to SIM swapping attacks
3. **X.509 Disabled** - Consider enabling for certificate-based auth
4. **No Conditional Access Visible** - May not be configured yet

#### 🎯 Recommendations
1. **Restrict SMS/Email** to emergency access only
2. **Enable X.509** for smart card scenarios
3. **Enforce FIDO2** for admin accounts
4. **Configure Conditional Access** for device compliance

---

## 4. Security Posture Assessment

### Current State
| Area | Status | Finding |
|------|--------|---------|
| **MFA Enforcement** | 🟡 Unknown | No Conditional Access policies visible |
| **Passwordless** | 🟢 Enabled | FIDO2 available but adoption unknown |
| **Risk-Based Auth** | 🔴 Not visible | No risk policies detected |
| **Device Compliance** | 🔴 Unknown | Intune enrollment unclear |
| **Session Management** | 🔴 Unknown | Token lifetime policies not audited |

### GitHub Integration Status
- ✅ GitHub CLI authenticated (MarkMaconnachie)
- ✅ Comprehensive token scopes (admin, repo, workflow)
- ❌ No GitHub as Entra IdP federation detected
- ❌ No GitHub OAuth app in Entra visible yet

---

## 5. UniFi Integration Assessment

### Environment Variables Present
```bash
SPECTRA_UNIFI_TOKEN=**** (Present ✅)
SPECTRA_UNIFI_PORTAL_URL=**** (Present ✅)
SPECTRA_UNIFI_API_DOCUMENTATION_URL=**** (Present ✅)
SPECTRA_UNIFI_FABRIC_WORKSPACE_ID=**** (Present ✅)
```

### UniFi Codebase
- **Location:** `Data/unifi/` with extensive documentation
- **Components:** 
  - Network scanning
  - MCP server
  - Host inspection
  - Development guides
  - Copilot integration

### Integration Architecture Needed

#### Current Gap
UniFi infrastructure exists but **NO identity integration bridge** to Entra ID.

#### Proposed Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    SPECTRA Identity Hub                      │
│                      (Entra ID Core)                         │
└──────────────┬────────────────────────┬─────────────────────┘
               │                        │
     ┌─────────▼──────────┐   ┌────────▼────────────┐
     │  Primary Methods   │   │  External Context   │
     │  - YubiKey (FIDO2)│   │  - GitHub OAuth     │
     │  - Windows Hello  │   │  - UniFi Signals    │
     │  - Authenticator  │   │  - Location Data    │
     └────────────────────┘   └─────────┬───────────┘
                                        │
                              ┌─────────▼──────────┐
                              │ UniFi Middleware   │
                              │ (To Be Built)      │
                              └─────────┬──────────┘
                                        │
                              ┌─────────▼──────────┐
                              │ UniFi Infrastructure│
                              │ - Protect (FaceID) │
                              │ - Network          │
                              │ - Access Points    │
                              │ - Doorbell         │
                              └────────────────────┘
```

#### Required Components (Not Yet Built)
1. **UniFi Event Webhook Listener**
   - Receives UniFi Protect events (doorbell FaceID)
   - Receives UniFi Network events (device presence)
   
2. **Entra Custom Security Attributes Writer**
   - Updates user risk scores based on physical location
   - Sets custom attributes (e.g., `onPremises`, `facialAuthConfidence`)

3. **Conditional Access Policy Integrator**
   - Reads custom attributes
   - Adjusts authentication requirements dynamically
   - Example: If user at doorbell + FaceID + known device → skip MFA

4. **Audit & Logging Pipeline**
   - Correlate physical + digital auth events
   - Feed to Fabric lakehouse for AI analysis

---

## 6. Missing Infrastructure for Vision

### Identity Branding (Not Configured)
- [ ] Custom company branding
- [ ] Custom domain (login.spectra.*)
- [ ] Logo and colour scheme
- [ ] Custom sign-in page for B2C
- [ ] Email templates for MFA/invites

### GitHub Premium SSO (Not Configured)
- [ ] GitHub registered as external IdP
- [ ] OAuth/OIDC flow configuration
- [ ] Attribute mapping (GitHub → Entra)
- [ ] Custom claims for user experience

### Conditional Access (Unknown/Incomplete)
- [ ] MFA enforcement policies
- [ ] Device compliance requirements
- [ ] Risk-based access
- [ ] Named locations (office, home)
- [ ] UniFi network integration

### Device Management (Not Visible)
- [ ] Intune enrollment
- [ ] Windows Hello for Business config
- [ ] YubiKey provisioning workflow
- [ ] Compliance policies

---

## 7. Recommended Tooling Additions

### Tier 1: Critical (Install Immediately)
```powershell
# Terraform for IaC
choco install terraform -y

# Azure PowerShell for advanced scripting
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

# Bicep for ARM templates
az bicep install

# Add Entra PowerShell module
Install-Module -Name Microsoft.Graph -Scope CurrentUser -Force
```

### Tier 2: High Priority
```powershell
# REST client for API development
winget install bruno

# MSAL device code flow tester
pip install msal-interactive

# UniFi Python SDK
pip install aiounifi

# Python Graph SDK
pip install msgraph-sdk
```

### Tier 3: Nice to Have
```bash
# Insomnia REST client (alternative)
winget install Insomnia.Insomnia

# PowerShell UniFi module
Install-Module -Name UniFiTooling -Scope CurrentUser

# Azure AD Exporter for backup/audit
Install-Module -Name AADExporter -Scope CurrentUser
```

---

## 8. Strategic Recommendations

### Phase 1: Foundation (Weeks 1-2) 🏗️
**Goal:** Enterprise-grade authentication baseline

1. **Install Critical Tooling**
   - Terraform, Azure PowerShell, Bicep
   - Microsoft.Graph PowerShell module
   
2. **Configure Conditional Access**
   - Enforce MFA for all admins
   - Create named locations (office network)
   - Require compliant devices for sensitive apps

3. **Enable Enhanced Logging**
   - Sign-in logs to Log Analytics
   - Audit logs retention
   - Risky users/sign-ins monitoring

4. **Harden Authentication**
   - Disable SMS for admins
   - Enforce FIDO2 for privileged accounts
   - Configure authentication strength policies

### Phase 2: GitHub SSO & Branding (Weeks 3-4) ✨
**Goal:** Premium user experience

1. **GitHub OAuth Integration**
   - Register GitHub App for OAuth
   - Configure Entra External ID federation
   - Test sign-in flow with GitHub button
   
2. **Custom Branding**
   - Design identity banner (use existing `Data/branding` assets)
   - Configure company branding in Entra
   - Custom domain setup (login.spectra.*)
   - Email template customization

3. **YubiKey Rollout**
   - Procurement for key staff
   - FIDO2 registration workflow
   - Backup key provisioning

### Phase 3: UniFi Integration (Weeks 5-8) 🏢
**Goal:** Physical + digital identity fusion

1. **Middleware Development**
   ```
   Core/infrastructure/unifi-identity-bridge/
   ├── webhook-listener/      # Receives UniFi events
   ├── entra-updater/         # Updates custom attributes
   ├── policy-engine/         # Decision logic
   └── audit-logger/          # Event correlation
   ```

2. **UniFi Configuration**
   - Enable Protect event webhooks
   - Configure FaceID doorbell triggers
   - Network presence detection
   - Guest network automation

3. **Conditional Access Integration**
   - Custom security attributes schema
   - Policy rules using attributes
   - Risk signal integration
   - Testing & validation

4. **Monitoring & Refinement**
   - Dashboard in Fabric (existing infrastructure)
   - Alert rules for anomalies
   - User acceptance testing
   - Documentation for ops team

### Phase 4: Advanced Features (Weeks 9-12) 🚀
**Goal:** AI-powered adaptive authentication

1. **Machine Learning Integration**
   - Train model on auth patterns (Fabric)
   - Anomaly detection for access
   - Predictive MFA (skip when safe)
   - Automated policy recommendations

2. **Multi-Device Orchestration**
   - UniFi doorbell → auto-unlock PC
   - Windows Hello + physical presence = instant access
   - YubiKey as backup for unusual locations
   - Mobile app for push notifications

3. **Guest & Partner Access**
   - Guest UniFi network → Guest Entra access
   - Time-limited access tied to physical presence
   - Automated cleanup after checkout
   - Visitor logs correlation

---

## 9. Environment Secrets Assessment

### Present Identity Secrets ✅
```bash
SPECTRA_AZURE_TENANT_ID (✅ Matches audit)
SPECTRA_FABRIC_CLIENT_ID (✅ Present)
SPECTRA_FABRIC_CLIENT_SECRET (✅ Present)
SPECTRA_FABRIC_TENANT_ID (✅ Present)
SPECTRA_GRAPH_CLIENT_ID (✅ Present)
SPECTRA_GRAPH_CLIENT_SECRET (✅ Present)
SPECTRA_PORTAL_SPA_CLIENT_ID (✅ Present)
SPECTRA_UNIFI_TOKEN (✅ Present)
```

### Missing Secrets (Will Need)
```bash
SPECTRA_GITHUB_OAUTH_CLIENT_ID (❌ Not present)
SPECTRA_GITHUB_OAUTH_CLIENT_SECRET (❌ Not present)
SPECTRA_ENTRA_BRANDING_LOGO_URL (❌ Not present)
SPECTRA_IDENTITY_WEBHOOK_SECRET (❌ Not present)
SPECTRA_UNIFI_WEBHOOK_HMAC_KEY (❌ Not present)
```

---

## 10. Next Actions (Prioritized)

### Immediate (Today)
- [x] Complete tooling audit
- [ ] Install Terraform
- [ ] Install Microsoft.Graph PowerShell
- [ ] Document current Conditional Access state

### This Week
- [ ] Design UniFi-Entra middleware architecture
- [ ] Create GitHub OAuth app registration
- [ ] Design identity branding assets
- [ ] Configure first Conditional Access policy (MFA for admins)

### Next Week
- [ ] Build UniFi webhook listener (Python)
- [ ] Implement custom security attributes in Entra
- [ ] Test GitHub SSO flow
- [ ] Deploy custom branding

### Month 1
- [ ] Full UniFi integration live
- [ ] YubiKey rollout to core team
- [ ] Premium SSO experience deployed
- [ ] Monitoring dashboard in Fabric

---

## 11. Cost Considerations

### Entra ID Licensing Required
| Feature | licence Tier | Monthly Cost (per user) |
|---------|--------------|-------------------------|
| Basic MFA | **P1** | ~$6 |
| Conditional Access | **P1** | ~$6 |
| Risk-based policies | **P2** | ~$9 |
| Custom security attributes | **P1** | ~$6 |
| Passwordless (FIDO2) | **P1** | ~$6 |

**Recommendation:** Entra ID P2 for 6 key staff (~$54/mo), P1 for others (~$36/mo = 6 users)

### Infrastructure Costs
- **UniFi Equipment:** Already purchased ✅
- **YubiKeys:** ~$50 each × 6 = $300 one-time
- **Custom Domain:** ~$20/year
- **SSL Certificates:** Free (Let's Encrypt)
- **Middleware Hosting:** Railway/existing ($0 if using existing infra)

**Total Monthly:** ~$100-150 (mostly licensing)

---

## 12. Risk Assessment

### High Risks 🔴
1. **No MFA enforcement visible** - Critical for AI company
2. **Email/SMS OTP enabled** - Vulnerable authentication methods
3. **No Conditional Access** - Anyone, anywhere can potentially sign in
4. **UniFi integration gap** - Physical access not tied to digital identity

### Medium Risks 🟡
1. **Single authentication mode** - No device compliance checks
2. **No risk-based policies** - Can't auto-block suspicious activity
3. **Limited audit visibility** - Hard to detect compromise
4. **Shared accounts** (functional accounts) - Poor attribution

### Low Risks 🟢
1. **Good app separation** - Blast radius contained
2. **GitHub CLI authenticated** - Developer workflow secured
3. **Strong foundation** - Modern Entra ID platform

---

## Conclusion

**SPECTRA Data Solutions has a solid identity foundation** but needs strategic investments to achieve the vision of:
- **UniFi-integrated authentication** (physical + digital fusion)
- **Premium SSO experience** with GitHub
- **Multi-device 2FA** orchestration
- **AI-powered adaptive authentication**

**The tenant is ready for transformation.** With the right tooling additions and 8-12 weeks of focused development, SPECTRA can have an **industry-leading identity infrastructure** befitting an AI company.

**Next Step:** Review this audit, approve phased approach, and begin Phase 1 tooling installation.

---

**Audit Completed By:** AI Assistant (Cursor)  
**Review Required By:** Mark Maconnachie (mark@spectradatasolutions.com)  
**Last Updated:** 2025-11-28


