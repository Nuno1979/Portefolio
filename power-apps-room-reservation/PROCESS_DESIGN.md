# 📊 PROCESS DESIGN — Room Reservation Workflow

## 1. Process Overview

### **1.1 High-Level Workflow**

```
┌─────────────────────┐
│  USER SUBMITS FORM  │
│  (Tipo + Espaço)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────────────────────┐
│  FORM VALIDATION & ROUTING          │
│  • Tipo: Interno / Externo          │
│  • Espaço: Galeria / Auditório / ...│
└──────────┬──────────────────────────┘
           │
    ┌──────┴──────┐
    │             │
    ▼             ▼
┌─────────┐  ┌──────────────┐
│INTERNAL │  │ EXTERNAL     │
│REQUEST  │  │ REQUEST      │
└────┬────┘  └──────┬───────┘
     │              │
     │      ┌───────┴────────┐
     │      │                │
     ▼      ▼                ▼
  ┌──┴──┐┌────┐┌────────┐
  │GAL  ││AUD ││OTHERS  │
  └──┬──┘└─┬──┘└───┬────┘
     │     │       │
     │     │       ▼
     │     │    [REJECT]
     │     │    ❌ Not available
     │     │
     ▼     ▼
  ┌────────────────────┐
  │ AUTO-APPROVE       │
  │ Internal requests  │
  └────────┬───────────┘
           │
  ┌────────▼──────────┐
  │ PENDING APPROVAL  │
  │ External requests │
  └────────┬──────────┘
           │
     ┌─────┴─────┐
     │           │
     ▼           ▼
   [YES]       [NO]
     │           │
     ▼           ▼
  ┌─────┐     [REJECT]
  │[✓]  │      ❌
  │OK   │
  └──┬──┘
     │
     ▼
┌──────────────────────────┐
│ CREATE CALENDAR EVENT    │
│ • Add to correct calendar│
│ • Set date/time          │
│ • Add attendees/location │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ SEND EMAIL NOTIFICATION  │
│ • Confirmation or status │
│ • Include event details  │
│ • Add next steps         │
└──────────┬───────────────┘
           │
           ▼
┌──────────────────────────┐
│ LOG & AUDIT              │
│ • Store in database      │
│ • Create audit trail     │
│ • Enable tracking        │
└──────────────────────────┘
```

---

## 2. User Journeys

### **2.1 Internal User (AUTOMATIC APPROVAL)**

**Actor**: Docente, Estudante, Staff ESMAD

**Journey**:
```
1. Access Form
   ↓
2. Select "Tipo Utilizador" = "Interno"
   ↓
3. Select "Espaço Pretendido" (e.g., "Galeria")
   ↓
4. Form shows conditional section (Interno-Galeria)
   ↓
5. Fill event details:
   • Nome Evento
   • Data
   • Hora Início/Fim
   • Nome Requerente
   • Email
   • Outros campos da secção (Type de evento, etc.)
   ↓
6. Submit
   ↓
7. Power Automate processes:
   • Validates data
   • Checks calendar for conflicts
   • Creates event in "cal-galeria-int"
   • Sends confirmation email
   ↓
8. USER RECEIVES:
   • Email confirmation (< 1 min)
   • Event in Outlook calendar
   • Referência de pedido
   ↓
9. Event occurs at scheduled time
   ↓
10. Done ✓
```

**Outcome**: 
- ✅ Reservation confirmed
- ✅ Calendar updated
- ✅ Email sent
- ⏱️ Total time: < 1 minute

---

### **2.2 External User - Approved Space (PENDING APPROVAL)**

**Actor**: Consultor externo, Parceiro, Investigador visitante

**Journey**:
```
1. Access Form
   ↓
2. Select "Tipo Utilizador" = "Externo"
   ↓
3. Select "Espaço Pretendido" (e.g., "Auditório")
   ↓
4. Form shows conditional section (Externo-Auditório)
   ↓
5. Fill details:
   • Nome Evento
   • Data/Hora
   • Info pessoal
   • Comprovante vínculo
   • Etc.
   ↓
6. Submit
   ↓
7. Power Automate processes:
   • Validates data
   • Creates TENTATIVE event
   • Sends "PENDING APPROVAL" email to requester
   • Sends alert to cpr@esmad.pt
   ↓
8. USER RECEIVES:
   • Email: "Sua reserva está em análise"
   • CPR manager notified
   ↓
9. CPR Manager Reviews:
   • Checks request details
   • Approves or rejects
   ↓
10a. IF APPROVED:
   • Event status changes to Confirmed
   • Email sent to requester: "Aprovada"
   ↓
10b. IF REJECTED:
   • Event deleted
   • Email sent to requester: "Recusada (reason)"
   ↓
11. Done ✓ or ✗
```

**Outcome**:
- ⏳ Reservation pending (manager approval)
- 📧 Emails sent to all parties
- 📋 Request tracked and auditable

**SLA**: Manager should review within 24h

---

### **2.3 External User - Non-Approved Space (AUTOMATIC REJECTION)**

**Actor**: External user

**Journey**:
```
1. Access Form
   ↓
2. Select "Tipo Utilizador" = "Externo"
   ↓
3. Select "Espaço Pretendido" (e.g., "Sala de Reunião")
   ↓
4. Form shows ONLY common section (no conditional)
   ↓
5. Fill details and submit
   ↓
6. Power Automate processes:
   • Detects: Externo + Non-Approved Space
   • Automatic rejection rule triggered
   ↓
7. USER RECEIVES:
   • Email: "Reserva Recusada"
   • Reason: "Espaço não disponível para utilizadores externos"
   • Contact: cpr@esmad.pt
   ↓
8. Done ✗
```

**Outcome**:
- ❌ Reservation rejected automatically
- 📧 Notification sent with reason
- 🚦 Redirects to CPR for manual handling

---

## 3. Decision Trees

### **3.1 Routing Logic**

```
┌─ START: Form Submission
│
└─ DECISION: Tipo Utilizador?
   │
   ├─ [INTERNO]
   │  │
   │  └─ DECISION: Espaço?
   │     │
   │     ├─ [GALERIA]
   │     │  └─ PROFILE: "Interno-Galeria"
   │     │     └─ ACTION: Auto-approve + Create event (cal-galeria-int)
   │     │
   │     ├─ [AUDITÓRIO]
   │     │  └─ PROFILE: "Interno-Auditório"
   │     │     └─ ACTION: Auto-approve + Create event (cal-auditorio-int)
   │     │
   │     └─ [OUTRAS SALAS]
   │        └─ PROFILE: "Interno-Salas"
   │           └─ ACTION: Auto-approve + Create event (cal-salas-int)
   │
   └─ [EXTERNO]
      │
      └─ DECISION: Espaço?
         │
         ├─ [GALERIA]
         │  └─ PROFILE: "Externo-Galeria"
         │     └─ ACTION: Pending approval + CC cpr@esmad.pt
         │
         ├─ [AUDITÓRIO]
         │  └─ PROFILE: "Externo-Auditório"
         │     └─ ACTION: Pending approval + CC cpr@esmad.pt
         │
         └─ [OUTRAS]
            └─ ACTION: AUTO-REJECT
               └─ Send rejection email
```

### **3.2 Approval Decision (CPR Manager)**

```
REQUEST RECEIVED (Externo + Approved Space)
│
├─ REVIEW: Event details, external profile verification
│
├─ DECISION: Approve?
│  │
│  ├─ [YES]
│  │  ├─ Status: Confirmada
│  │  ├─ Email to requester: "Aprovada"
│  │  ├─ Email to staff: "New event scheduled"
│  │  └─ Calendar: Event confirmed
│  │
│  └─ [NO]
│     ├─ Status: Recusada
│     ├─ Email to requester: "Recusada (reason)"
│     ├─ Email to staff: "Request rejected"
│     └─ Calendar: Event deleted
│
└─ DONE
```

---

## 4. System States

### **4.1 Request States**

| State | Meaning | Action | Email Status |
|-------|---------|--------|--------------|
| **SUBMITTED** | Form received | Processing... | — |
| **VALIDATED** | Data OK | Continue | — |
| **CONFLICT** | Calendar conflict | Reject | "Conflito de horário" |
| **APPROVED** | Auto or manually approved | Create event | "Confirmada" ✓ |
| **PENDING** | Awaiting manager review | Notify manager | "Pendente Aprovação" |
| **REJECTED** | Denied (auto or manual) | Delete event | "Recusada" ✗ |
| **CONFIRMED** | Event scheduled | Monitor | "Reserva Confirmada" ✓ |
| **COMPLETED** | Event occurred | Archive | — |
| **CANCELLED** | User cancelled | Delete event | "Reserva Cancelada" |

---

## 5. Business Rules

### **5.1 Automatic Approval Rules**

```
✓ APPROVE IF:
  • Utilizador = Interno
  • Espaço ∈ [Galeria, Auditório, Outras Salas]
  • Data is in future
  • Time is valid (Fim > Início)
  • No calendar conflict on that date/time/calendar

✗ REJECT IF:
  • Utilizador = Externo AND Espaço NOT IN [Galeria, Auditório]
  • Data is in past
  • Time is invalid
  • Calendar conflict exists
```

### **5.2 Approval Flow Rules**

```
⏳ PENDING IF:
  • Utilizador = Externo
  • Espaço ∈ [Galeria, Auditório]
  • Data/Time valid
  • No conflict
  
  → Wait for CPR manager review (24h SLA)
```

### **5.3 Notification Rules**

```
EMAIL_TO_REQUESTER:
  • Always send status (Confirmada, Pendente, Recusada)
  • Include: Event name, date, time, location
  • Include: Reference ID for tracking

EMAIL_TO_CPR (IF needed):
  • Externo request submitted
  • Approval needed
  • Rejection/cancellation occurred
  
CC_TO_ADDITIONAL:
  • If Externo + requires special approval
  • Add subject matter expert email
```

---

## 6. Error Handling

### **6.1 Validation Errors**

```
IF empty(EventName) THEN
  Reject with: "Nome do evento é obrigatório"
  
IF past_date(ReservationDate) THEN
  Reject with: "Data deve ser futura"
  
IF TimeEnd <= TimeStart THEN
  Reject with: "Hora de término deve ser posterior ao início"
  
IF empty(Email) THEN
  Reject with: "Email de contacto é obrigatório"
```

### **6.2 System Errors**

```
IF Calendar API fails THEN
  • Log error
  • Send alert to IT
  • Notify requester: "Erro técnico, contacte suporte"
  • Escalate to manual review
  
IF Email sending fails THEN
  • Retry 3 times
  • If still fails, send alert to cpr@esmad.pt
  • User can manually send confirmation
```

---

## 7. Escalation Paths

### **7.1 When to Escalate**

```
AUTOMATIC ESCALATION TO CPR:
  ✓ Externo + Approved space (pending approval)
  ✓ Calendar conflict detected
  ✓ System error during processing
  ✓ Multiple rejections from same user

MANUAL ESCALATION:
  ✓ User disputes rejection
  ✓ Special request (weekend, after-hours)
  ✓ VIP visitor or important external event
```

### **7.2 Escalation Contact**

```
CPR Manager Email: cpr@esmad.pt
Facilities Manager: facility@esmad.pt
IT Support: it-support@esmad.pt
```

---

## 8. Process Metrics

### **8.1 Key Performance Indicators (KPIs)**

| Metric | Target | Measurement |
|--------|--------|-------------|
| Processing Time (Internal) | < 1 min | From submission to calendar event |
| Processing Time (External Pending) | < 5 min | From submission to manager notification |
| Approval Time (Manager) | 24h | From notification to decision |
| Calendar Conflict Rate | 0% | Zero conflicts post-implementation |
| Form Completion Rate | > 90% | Users successfully submitting |
| Email Delivery Rate | 99.9% | Confirmations reaching users |
| System Uptime | 99.9% | Availability 24/7 |

### **8.2 Monitoring Dashboard**

```
Track weekly:
- Total reservations processed
- Approved vs. rejected vs. pending
- Average processing time
- Calendar conflicts (should be 0)
- Failed attempts
- User satisfaction
```

---

## 9. Communication Plan

### **9.1 User Notifications**

**Email Status Updates**:
- Submission acknowledgment (immediate)
- Approval/rejection (immediate for auto, < 24h for manual)
- Calendar sync confirmation
- Cancellation confirmation (if applicable)

**Email Content**:
- Event name, date, time, location
- Request reference ID
- Action taken (Approved/Pending/Rejected)
- Next steps
- Contact for questions

---

## 10. Change Management

### **10.1 Adding a New Room**

**Process**:
1. Request from Facilities
2. Update Forms (add to dropdown)
3. Update Room Mapping JSON in Flow
4. Test with sample submission
5. Deploy and notify users

**Timeline**: 24 hours

### **10.2 Modifying Approval Rules**

**Process**:
1. Define new rule
2. Update Flow logic
3. Test all scenarios
4. Get approval from CPR
5. Deploy

**Timeline**: 2-3 business days

### **10.3 System Maintenance**

**Planned**:
- Forms backup: Weekly
- Flow monitoring: Daily
- System review: Monthly

**Unplanned**:
- Immediate incident response
- Escalation to Microsoft if needed
- Manual approval fallback

---

## 11. Related Documentation

- **README.md** – Project overview and impact
- **TECHNICAL_SPECIFICATION.md** – System architecture details
- **IMPLEMENTATION_GUIDE.md** – Step-by-step setup
- **ARCHITECTURE_DIAGRAM** – Visual flow diagram (images/)
