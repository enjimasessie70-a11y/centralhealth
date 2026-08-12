-- CreateEnum
CREATE TYPE "ReferralStatus" AS ENUM ('PENDING', 'ACCEPTED', 'REJECTED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "ReferralPriority" AS ENUM ('ROUTINE', 'URGENT', 'EMERGENCY');

-- CreateEnum
CREATE TYPE "AntenatalStatus" AS ENUM ('ACTIVE', 'COMPLETED', 'REFERRED', 'TRANSFERRED');

-- CreateEnum
CREATE TYPE "CareLevel" AS ENUM ('NORMAL', 'INTENSIVE', 'CRITICAL');

-- CreateEnum
CREATE TYPE "DischargeStatus" AS ENUM ('READY', 'NOT_READY');

-- CreateEnum
CREATE TYPE "NeonatalStatus" AS ENUM ('ACTIVE', 'DISCHARGED', 'TRANSFERRED', 'DECEASED');

-- CreateEnum
CREATE TYPE "RiskLevel" AS ENUM ('LOW', 'MEDIUM', 'HIGH');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('PATIENT', 'DOCTOR', 'STAFF', 'MANAGER', 'ADMIN');

-- CreateEnum
CREATE TYPE "EmploymentStatus" AS ENUM ('ACTIVE', 'ON_LEAVE', 'SUSPENDED', 'TERMINATED');

-- CreateEnum
CREATE TYPE "AccessLevel" AS ENUM ('READ', 'WRITE', 'ADMIN');

-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('SCHEDULED', 'CONFIRMED', 'COMPLETED', 'CANCELLED', 'NO_SHOW');

-- CreateEnum
CREATE TYPE "AmbulanceType" AS ENUM ('BASIC', 'ADVANCED', 'NEONATAL', 'MOBILE_ICU');

-- CreateEnum
CREATE TYPE "AmbulanceStatus" AS ENUM ('AVAILABLE', 'DISPATCHED', 'IN_MAINTENANCE', 'OUT_OF_SERVICE');

-- CreateEnum
CREATE TYPE "DispatchPriority" AS ENUM ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL');

-- CreateEnum
CREATE TYPE "DispatchStatus" AS ENUM ('REQUESTED', 'DISPATCHED', 'EN_ROUTE', 'ARRIVED', 'COMPLETED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "WalletStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'CLOSED');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('DEPOSIT', 'WITHDRAWAL', 'PAYMENT', 'REFUND', 'TRANSFER');

-- CreateEnum
CREATE TYPE "TransactionStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REVERSED');

-- CreateEnum
CREATE TYPE "BillingStatus" AS ENUM ('PENDING', 'PARTIAL', 'PAID', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'CARD', 'TRANSFER', 'MOBILE_MONEY', 'INSURANCE');

-- CreateEnum
CREATE TYPE "ConversationStatus" AS ENUM ('ACTIVE', 'ARCHIVED', 'BLOCKED');

-- CreateEnum
CREATE TYPE "MessageStatus" AS ENUM ('SENT', 'DELIVERED', 'READ');

-- CreateEnum
CREATE TYPE "DeliveryMethod" AS ENUM ('NATURAL', 'CESAREAN', 'ASSISTED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED', 'RETURNED');

-- CreateTable
CREATE TABLE "AntenatalRecord" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "gestationalAge" INTEGER NOT NULL,
    "nextAppointment" TIMESTAMP(3),
    "riskLevel" "RiskLevel" NOT NULL DEFAULT 'LOW',
    "status" "AntenatalStatus" NOT NULL DEFAULT 'ACTIVE',
    "trimester" INTEGER NOT NULL DEFAULT 1,
    "lastVisitDate" TIMESTAMP(3),
    "expectedDueDate" TIMESTAMP(3) NOT NULL,
    "ultrasoundReports" JSONB,
    "labResults" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdByUserId" TEXT NOT NULL,
    "updatedByUserId" TEXT NOT NULL,
    "mrn" TEXT,

    CONSTRAINT "AntenatalRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Appointment" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "status" "AppointmentStatus" NOT NULL,

    CONSTRAINT "Appointment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Hospital" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "subdomain" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "settings" JSONB NOT NULL,
    "branding" JSONB,
    "code" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Hospital_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MedicalRecord" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "details" JSONB NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "hospitalId" TEXT NOT NULL,

    CONSTRAINT "MedicalRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "NeonatalRecord" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "birthWeight" DOUBLE PRECISION NOT NULL,
    "gestationalAgeAtBirth" INTEGER NOT NULL,
    "careLevel" "CareLevel" NOT NULL DEFAULT 'NORMAL',
    "status" "NeonatalStatus" NOT NULL DEFAULT 'ACTIVE',
    "dischargeStatus" "DischargeStatus",
    "apgarScore" INTEGER,
    "motherId" TEXT,
    "birthComplications" TEXT,
    "feedingMethod" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdByUserId" TEXT NOT NULL,
    "updatedByUserId" TEXT NOT NULL,
    "mrn" TEXT,

    CONSTRAINT "NeonatalRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Patient" (
    "id" TEXT NOT NULL,
    "mrn" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "dateOfBirth" TIMESTAMP(3),
    "gender" TEXT,
    "medicalHistory" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "onboardingCompleted" BOOLEAN NOT NULL DEFAULT false,
    "hospitalId" TEXT,
    "lastVisit" TIMESTAMP(3),
    "nextVisit" TIMESTAMP(3),
    "note" TEXT,
    "qrCode" TEXT,
    "userId" TEXT,

    CONSTRAINT "Patient_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "hospitalId" TEXT,
    "isHospitalAdmin" BOOLEAN NOT NULL DEFAULT false,
    "isSuperAdmin" BOOLEAN NOT NULL DEFAULT false,
    "phone" TEXT,
    "photo" TEXT,
    "specialties" TEXT[],
    "role" "UserRole" NOT NULL DEFAULT 'STAFF',

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "password_resets" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "email" TEXT,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "usedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "patientId" TEXT,
    "userId" TEXT,

    CONSTRAINT "password_resets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "security_audit_logs" (
    "id" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "requestPath" TEXT,
    "success" BOOLEAN NOT NULL DEFAULT true,
    "details" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "security_audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profile_pictures" (
    "id" TEXT NOT NULL,
    "patientId" TEXT,
    "userId" TEXT,
    "imageUrl" TEXT NOT NULL,
    "imageData" BYTEA,
    "mimeType" TEXT NOT NULL,
    "filename" TEXT,
    "size" INTEGER NOT NULL,
    "width" INTEGER,
    "height" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "uploadedBy" TEXT,
    "ownerType" TEXT NOT NULL,

    CONSTRAINT "profile_pictures_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_emails" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "primary" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "patientId" TEXT NOT NULL,

    CONSTRAINT "patient_emails_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "patient_phones" (
    "id" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "primary" BOOLEAN NOT NULL DEFAULT false,
    "type" TEXT NOT NULL DEFAULT 'mobile',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "patientId" TEXT NOT NULL,

    CONSTRAINT "patient_phones_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Department" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "hospitalId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DepartmentMembership" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "departmentId" TEXT NOT NULL,
    "role" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "DepartmentMembership_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StaffProfile" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "staffId" TEXT NOT NULL,
    "specialization" TEXT,
    "qualifications" JSONB,
    "joiningDate" TIMESTAMP(3) NOT NULL,
    "employmentStatus" "EmploymentStatus" NOT NULL,
    "contactInformation" JSONB,

    CONSTRAINT "StaffProfile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PatientHospitalAccess" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "accessLevel" "AccessLevel" NOT NULL,
    "grantedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "grantedBy" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3),

    CONSTRAINT "PatientHospitalAccess_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PatientSearchIndex" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "mrn" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "email" TEXT,
    "qrCode" TEXT NOT NULL,
    "searchVector" TEXT,

    CONSTRAINT "PatientSearchIndex_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DoctorAvailability" (
    "id" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "available" BOOLEAN NOT NULL DEFAULT false,
    "schedule" JSONB NOT NULL,
    "serviceTypes" TEXT[],
    "nextAvailable" TIMESTAMP(3),

    CONSTRAINT "DoctorAvailability_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PatientWidgetPreference" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "recentDoctors" TEXT[],
    "preferredHospitals" TEXT[],
    "searchHistory" JSONB,

    CONSTRAINT "PatientWidgetPreference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Referral" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "fromHospitalId" TEXT NOT NULL,
    "toHospitalId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "notes" TEXT,
    "priority" "ReferralPriority" NOT NULL DEFAULT 'ROUTINE',
    "status" "ReferralStatus" NOT NULL DEFAULT 'PENDING',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),
    "referralCode" TEXT NOT NULL,
    "requiresAmbulance" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Referral_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StatusHistory" (
    "id" TEXT NOT NULL,
    "referralId" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "changedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "changedBy" TEXT NOT NULL,

    CONSTRAINT "StatusHistory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ambulance" (
    "id" TEXT NOT NULL,
    "registrationNo" TEXT NOT NULL,
    "type" "AmbulanceType" NOT NULL,
    "status" "AmbulanceStatus" NOT NULL DEFAULT 'AVAILABLE',
    "hospitalId" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL DEFAULT 1,
    "equipment" JSONB,
    "features" TEXT[],
    "gpsTracking" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "lastMaintenance" TIMESTAMP(3),

    CONSTRAINT "Ambulance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AmbulanceDispatch" (
    "id" TEXT NOT NULL,
    "ambulanceId" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "pickupLocation" TEXT NOT NULL,
    "dropLocation" TEXT NOT NULL,
    "dispatchTime" TIMESTAMP(3) NOT NULL,
    "arrivalTime" TIMESTAMP(3),
    "completionTime" TIMESTAMP(3),
    "priority" "DispatchPriority" NOT NULL DEFAULT 'MEDIUM',
    "status" "DispatchStatus" NOT NULL DEFAULT 'REQUESTED',
    "dispatchedBy" TEXT NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AmbulanceDispatch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AmbulanceRequest" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "pickupLocation" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "requestTime" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" "DispatchStatus" NOT NULL DEFAULT 'REQUESTED',
    "priority" "DispatchPriority" NOT NULL DEFAULT 'MEDIUM',
    "contactName" TEXT NOT NULL,
    "contactPhone" TEXT NOT NULL,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AmbulanceRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Wallet" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "balance" DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "WalletStatus" NOT NULL DEFAULT 'ACTIVE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Wallet_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WalletTransaction" (
    "id" TEXT NOT NULL,
    "walletId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "type" "TransactionType" NOT NULL,
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "reference" TEXT NOT NULL,
    "description" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "WalletTransaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Billing" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "status" "BillingStatus" NOT NULL DEFAULT 'PENDING',
    "description" TEXT NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "items" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "paidAt" TIMESTAMP(3),

    CONSTRAINT "Billing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" TEXT NOT NULL,
    "billingId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "method" "PaymentMethod" NOT NULL,
    "reference" TEXT NOT NULL,
    "status" "TransactionStatus" NOT NULL DEFAULT 'PENDING',
    "transactionId" TEXT,
    "receiptNumber" TEXT NOT NULL,
    "paymentDate" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Conversation" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "doctorId" TEXT,
    "title" TEXT,
    "status" "ConversationStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastMessageAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Conversation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Message" (
    "id" TEXT NOT NULL,
    "conversationId" TEXT NOT NULL,
    "senderId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "attachments" JSONB,
    "status" "MessageStatus" NOT NULL DEFAULT 'SENT',
    "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deliveredAt" TIMESTAMP(3),
    "readAt" TIMESTAMP(3),

    CONSTRAINT "Message_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "BirthRecord" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "motherId" TEXT,
    "fatherId" TEXT,
    "hospitalId" TEXT NOT NULL,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "birthTime" TEXT,
    "birthWeight" DOUBLE PRECISION,
    "deliveryMethod" "DeliveryMethod" NOT NULL DEFAULT 'NATURAL',
    "attendingDoctorId" TEXT NOT NULL,
    "birthPlace" TEXT,
    "certificateNumber" TEXT NOT NULL,
    "registeredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "complications" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "apgarScore" INTEGER,
    "gestationalAge" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "BirthRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "DeathRecord" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "dateOfDeath" TIMESTAMP(3) NOT NULL,
    "timeOfDeath" TEXT,
    "causeOfDeath" TEXT,
    "attendingDoctorId" TEXT NOT NULL,
    "placeOfDeath" TEXT NOT NULL,
    "certificateNumber" TEXT NOT NULL,
    "registeredAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "DeathRecord_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MarketplaceVendor" (
    "id" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "contactEmail" TEXT,
    "contactPhone" TEXT,
    "address" TEXT,
    "logo" TEXT,
    "websiteUrl" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "rating" DOUBLE PRECISION,
    "specialties" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MarketplaceVendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MarketplaceProduct" (
    "id" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DOUBLE PRECISION NOT NULL,
    "discountPrice" DOUBLE PRECISION,
    "category" TEXT NOT NULL,
    "tags" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "imageUrl" TEXT,
    "inStock" BOOLEAN NOT NULL DEFAULT true,
    "requiredPrescription" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MarketplaceProduct_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MarketplaceOrder" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "reference" TEXT NOT NULL,
    "totalAmount" DOUBLE PRECISION NOT NULL,
    "status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "paymentStatus" TEXT,
    "shippingAddress" TEXT,
    "trackingNumber" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MarketplaceOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OrderItem" (
    "id" TEXT NOT NULL,
    "orderId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unitPrice" DOUBLE PRECISION NOT NULL,
    "totalPrice" DOUBLE PRECISION NOT NULL,
    "prescriptionId" TEXT,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CartItem" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "addedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CartItem_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SavedVendor" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "vendorId" TEXT NOT NULL,
    "savedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SavedVendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Prescription" (
    "id" TEXT NOT NULL,
    "patientId" TEXT NOT NULL,
    "doctorId" TEXT NOT NULL,
    "hospitalId" TEXT NOT NULL,
    "medications" JSONB NOT NULL,
    "dosageInstructions" TEXT,
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validUntil" TIMESTAMP(3),
    "filledStatus" BOOLEAN NOT NULL DEFAULT false,
    "filledDate" TIMESTAMP(3),
    "refills" INTEGER NOT NULL DEFAULT 0,
    "refillsUsed" INTEGER NOT NULL DEFAULT 0,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Prescription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_DoctorPatients" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_DoctorPatients_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "AntenatalRecord_mrn_key" ON "AntenatalRecord"("mrn");

-- CreateIndex
CREATE INDEX "AntenatalRecord_hospitalId_idx" ON "AntenatalRecord"("hospitalId");

-- CreateIndex
CREATE INDEX "AntenatalRecord_patientId_idx" ON "AntenatalRecord"("patientId");

-- CreateIndex
CREATE INDEX "AntenatalRecord_riskLevel_idx" ON "AntenatalRecord"("riskLevel");

-- CreateIndex
CREATE INDEX "AntenatalRecord_status_idx" ON "AntenatalRecord"("status");

-- CreateIndex
CREATE INDEX "Appointment_patientId_idx" ON "Appointment"("patientId");

-- CreateIndex
CREATE INDEX "Appointment_doctorId_idx" ON "Appointment"("doctorId");

-- CreateIndex
CREATE INDEX "Appointment_hospitalId_idx" ON "Appointment"("hospitalId");

-- CreateIndex
CREATE INDEX "Appointment_date_idx" ON "Appointment"("date");

-- CreateIndex
CREATE INDEX "Appointment_status_idx" ON "Appointment"("status");

-- CreateIndex
CREATE UNIQUE INDEX "Hospital_subdomain_key" ON "Hospital"("subdomain");

-- CreateIndex
CREATE UNIQUE INDEX "Hospital_code_key" ON "Hospital"("code");

-- CreateIndex
CREATE INDEX "Hospital_isActive_idx" ON "Hospital"("isActive");

-- CreateIndex
CREATE INDEX "Hospital_code_idx" ON "Hospital"("code");

-- CreateIndex
CREATE INDEX "MedicalRecord_patientId_idx" ON "MedicalRecord"("patientId");

-- CreateIndex
CREATE INDEX "MedicalRecord_doctorId_idx" ON "MedicalRecord"("doctorId");

-- CreateIndex
CREATE INDEX "MedicalRecord_hospitalId_idx" ON "MedicalRecord"("hospitalId");

-- CreateIndex
CREATE INDEX "MedicalRecord_type_idx" ON "MedicalRecord"("type");

-- CreateIndex
CREATE INDEX "MedicalRecord_date_idx" ON "MedicalRecord"("date");

-- CreateIndex
CREATE UNIQUE INDEX "NeonatalRecord_mrn_key" ON "NeonatalRecord"("mrn");

-- CreateIndex
CREATE INDEX "NeonatalRecord_careLevel_idx" ON "NeonatalRecord"("careLevel");

-- CreateIndex
CREATE INDEX "NeonatalRecord_hospitalId_idx" ON "NeonatalRecord"("hospitalId");

-- CreateIndex
CREATE INDEX "NeonatalRecord_motherId_idx" ON "NeonatalRecord"("motherId");

-- CreateIndex
CREATE INDEX "NeonatalRecord_patientId_idx" ON "NeonatalRecord"("patientId");

-- CreateIndex
CREATE INDEX "NeonatalRecord_status_idx" ON "NeonatalRecord"("status");

-- CreateIndex
CREATE UNIQUE INDEX "Patient_mrn_key" ON "Patient"("mrn");

-- CreateIndex
CREATE UNIQUE INDEX "Patient_userId_key" ON "Patient"("userId");

-- CreateIndex
CREATE INDEX "Patient_mrn_idx" ON "Patient"("mrn");

-- CreateIndex
CREATE INDEX "Patient_name_idx" ON "Patient"("name");

-- CreateIndex
CREATE INDEX "Patient_qrCode_idx" ON "Patient"("qrCode");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_hospitalId_idx" ON "User"("hospitalId");

-- CreateIndex
CREATE INDEX "User_role_idx" ON "User"("role");

-- CreateIndex
CREATE INDEX "User_isSuperAdmin_idx" ON "User"("isSuperAdmin");

-- CreateIndex
CREATE INDEX "User_isHospitalAdmin_idx" ON "User"("isHospitalAdmin");

-- CreateIndex
CREATE INDEX "User_specialties_idx" ON "User"("specialties");

-- CreateIndex
CREATE INDEX "security_audit_logs_userId_idx" ON "security_audit_logs"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "profile_pictures_patientId_key" ON "profile_pictures"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "profile_pictures_userId_key" ON "profile_pictures"("userId");

-- CreateIndex
CREATE INDEX "profile_pictures_patientId_idx" ON "profile_pictures"("patientId");

-- CreateIndex
CREATE INDEX "profile_pictures_userId_idx" ON "profile_pictures"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "patient_emails_email_key" ON "patient_emails"("email");

-- CreateIndex
CREATE INDEX "patient_emails_patientId_idx" ON "patient_emails"("patientId");

-- CreateIndex
CREATE INDEX "patient_phones_patientId_idx" ON "patient_phones"("patientId");

-- CreateIndex
CREATE INDEX "Department_hospitalId_idx" ON "Department"("hospitalId");

-- CreateIndex
CREATE INDEX "DepartmentMembership_userId_idx" ON "DepartmentMembership"("userId");

-- CreateIndex
CREATE INDEX "DepartmentMembership_departmentId_idx" ON "DepartmentMembership"("departmentId");

-- CreateIndex
CREATE UNIQUE INDEX "DepartmentMembership_userId_departmentId_key" ON "DepartmentMembership"("userId", "departmentId");

-- CreateIndex
CREATE UNIQUE INDEX "StaffProfile_userId_key" ON "StaffProfile"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "StaffProfile_staffId_key" ON "StaffProfile"("staffId");

-- CreateIndex
CREATE INDEX "StaffProfile_userId_idx" ON "StaffProfile"("userId");

-- CreateIndex
CREATE INDEX "StaffProfile_hospitalId_idx" ON "StaffProfile"("hospitalId");

-- CreateIndex
CREATE INDEX "StaffProfile_staffId_idx" ON "StaffProfile"("staffId");

-- CreateIndex
CREATE INDEX "PatientHospitalAccess_patientId_idx" ON "PatientHospitalAccess"("patientId");

-- CreateIndex
CREATE INDEX "PatientHospitalAccess_hospitalId_idx" ON "PatientHospitalAccess"("hospitalId");

-- CreateIndex
CREATE UNIQUE INDEX "PatientHospitalAccess_patientId_hospitalId_key" ON "PatientHospitalAccess"("patientId", "hospitalId");

-- CreateIndex
CREATE UNIQUE INDEX "PatientSearchIndex_patientId_key" ON "PatientSearchIndex"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "PatientSearchIndex_mrn_key" ON "PatientSearchIndex"("mrn");

-- CreateIndex
CREATE UNIQUE INDEX "PatientSearchIndex_qrCode_key" ON "PatientSearchIndex"("qrCode");

-- CreateIndex
CREATE INDEX "PatientSearchIndex_mrn_idx" ON "PatientSearchIndex"("mrn");

-- CreateIndex
CREATE INDEX "PatientSearchIndex_name_idx" ON "PatientSearchIndex"("name");

-- CreateIndex
CREATE INDEX "PatientSearchIndex_phone_idx" ON "PatientSearchIndex"("phone");

-- CreateIndex
CREATE INDEX "PatientSearchIndex_email_idx" ON "PatientSearchIndex"("email");

-- CreateIndex
CREATE UNIQUE INDEX "DoctorAvailability_doctorId_key" ON "DoctorAvailability"("doctorId");

-- CreateIndex
CREATE INDEX "DoctorAvailability_doctorId_idx" ON "DoctorAvailability"("doctorId");

-- CreateIndex
CREATE INDEX "DoctorAvailability_hospitalId_idx" ON "DoctorAvailability"("hospitalId");

-- CreateIndex
CREATE INDEX "DoctorAvailability_available_idx" ON "DoctorAvailability"("available");

-- CreateIndex
CREATE INDEX "DoctorAvailability_nextAvailable_idx" ON "DoctorAvailability"("nextAvailable");

-- CreateIndex
CREATE UNIQUE INDEX "PatientWidgetPreference_patientId_key" ON "PatientWidgetPreference"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "Referral_referralCode_key" ON "Referral"("referralCode");

-- CreateIndex
CREATE INDEX "Referral_patientId_idx" ON "Referral"("patientId");

-- CreateIndex
CREATE INDEX "Referral_fromHospitalId_idx" ON "Referral"("fromHospitalId");

-- CreateIndex
CREATE INDEX "Referral_toHospitalId_idx" ON "Referral"("toHospitalId");

-- CreateIndex
CREATE INDEX "StatusHistory_referralId_idx" ON "StatusHistory"("referralId");

-- CreateIndex
CREATE UNIQUE INDEX "Ambulance_registrationNo_key" ON "Ambulance"("registrationNo");

-- CreateIndex
CREATE INDEX "Ambulance_hospitalId_idx" ON "Ambulance"("hospitalId");

-- CreateIndex
CREATE INDEX "Ambulance_type_idx" ON "Ambulance"("type");

-- CreateIndex
CREATE INDEX "Ambulance_status_idx" ON "Ambulance"("status");

-- CreateIndex
CREATE INDEX "AmbulanceDispatch_ambulanceId_idx" ON "AmbulanceDispatch"("ambulanceId");

-- CreateIndex
CREATE INDEX "AmbulanceDispatch_patientId_idx" ON "AmbulanceDispatch"("patientId");

-- CreateIndex
CREATE INDEX "AmbulanceDispatch_hospitalId_idx" ON "AmbulanceDispatch"("hospitalId");

-- CreateIndex
CREATE INDEX "AmbulanceDispatch_status_idx" ON "AmbulanceDispatch"("status");

-- CreateIndex
CREATE INDEX "AmbulanceDispatch_priority_idx" ON "AmbulanceDispatch"("priority");

-- CreateIndex
CREATE INDEX "AmbulanceRequest_patientId_idx" ON "AmbulanceRequest"("patientId");

-- CreateIndex
CREATE INDEX "AmbulanceRequest_hospitalId_idx" ON "AmbulanceRequest"("hospitalId");

-- CreateIndex
CREATE INDEX "AmbulanceRequest_status_idx" ON "AmbulanceRequest"("status");

-- CreateIndex
CREATE INDEX "AmbulanceRequest_priority_idx" ON "AmbulanceRequest"("priority");

-- CreateIndex
CREATE UNIQUE INDEX "Wallet_patientId_key" ON "Wallet"("patientId");

-- CreateIndex
CREATE INDEX "Wallet_patientId_idx" ON "Wallet"("patientId");

-- CreateIndex
CREATE INDEX "Wallet_status_idx" ON "Wallet"("status");

-- CreateIndex
CREATE UNIQUE INDEX "WalletTransaction_reference_key" ON "WalletTransaction"("reference");

-- CreateIndex
CREATE INDEX "WalletTransaction_walletId_idx" ON "WalletTransaction"("walletId");

-- CreateIndex
CREATE INDEX "WalletTransaction_type_idx" ON "WalletTransaction"("type");

-- CreateIndex
CREATE INDEX "WalletTransaction_status_idx" ON "WalletTransaction"("status");

-- CreateIndex
CREATE INDEX "WalletTransaction_reference_idx" ON "WalletTransaction"("reference");

-- CreateIndex
CREATE UNIQUE INDEX "Billing_invoiceNumber_key" ON "Billing"("invoiceNumber");

-- CreateIndex
CREATE INDEX "Billing_patientId_idx" ON "Billing"("patientId");

-- CreateIndex
CREATE INDEX "Billing_hospitalId_idx" ON "Billing"("hospitalId");

-- CreateIndex
CREATE INDEX "Billing_status_idx" ON "Billing"("status");

-- CreateIndex
CREATE INDEX "Billing_invoiceNumber_idx" ON "Billing"("invoiceNumber");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_reference_key" ON "Payment"("reference");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_transactionId_key" ON "Payment"("transactionId");

-- CreateIndex
CREATE UNIQUE INDEX "Payment_receiptNumber_key" ON "Payment"("receiptNumber");

-- CreateIndex
CREATE INDEX "Payment_billingId_idx" ON "Payment"("billingId");

-- CreateIndex
CREATE INDEX "Payment_method_idx" ON "Payment"("method");

-- CreateIndex
CREATE INDEX "Payment_status_idx" ON "Payment"("status");

-- CreateIndex
CREATE INDEX "Payment_reference_idx" ON "Payment"("reference");

-- CreateIndex
CREATE INDEX "Payment_receiptNumber_idx" ON "Payment"("receiptNumber");

-- CreateIndex
CREATE INDEX "Conversation_patientId_idx" ON "Conversation"("patientId");

-- CreateIndex
CREATE INDEX "Conversation_hospitalId_idx" ON "Conversation"("hospitalId");

-- CreateIndex
CREATE INDEX "Conversation_doctorId_idx" ON "Conversation"("doctorId");

-- CreateIndex
CREATE INDEX "Conversation_status_idx" ON "Conversation"("status");

-- CreateIndex
CREATE INDEX "Conversation_lastMessageAt_idx" ON "Conversation"("lastMessageAt");

-- CreateIndex
CREATE INDEX "Message_conversationId_idx" ON "Message"("conversationId");

-- CreateIndex
CREATE INDEX "Message_senderId_idx" ON "Message"("senderId");

-- CreateIndex
CREATE INDEX "Message_status_idx" ON "Message"("status");

-- CreateIndex
CREATE INDEX "Message_sentAt_idx" ON "Message"("sentAt");

-- CreateIndex
CREATE UNIQUE INDEX "BirthRecord_patientId_key" ON "BirthRecord"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "BirthRecord_certificateNumber_key" ON "BirthRecord"("certificateNumber");

-- CreateIndex
CREATE INDEX "BirthRecord_patientId_idx" ON "BirthRecord"("patientId");

-- CreateIndex
CREATE INDEX "BirthRecord_motherId_idx" ON "BirthRecord"("motherId");

-- CreateIndex
CREATE INDEX "BirthRecord_fatherId_idx" ON "BirthRecord"("fatherId");

-- CreateIndex
CREATE INDEX "BirthRecord_hospitalId_idx" ON "BirthRecord"("hospitalId");

-- CreateIndex
CREATE INDEX "BirthRecord_birthDate_idx" ON "BirthRecord"("birthDate");

-- CreateIndex
CREATE INDEX "BirthRecord_certificateNumber_idx" ON "BirthRecord"("certificateNumber");

-- CreateIndex
CREATE UNIQUE INDEX "DeathRecord_patientId_key" ON "DeathRecord"("patientId");

-- CreateIndex
CREATE UNIQUE INDEX "DeathRecord_certificateNumber_key" ON "DeathRecord"("certificateNumber");

-- CreateIndex
CREATE INDEX "DeathRecord_patientId_idx" ON "DeathRecord"("patientId");

-- CreateIndex
CREATE INDEX "DeathRecord_hospitalId_idx" ON "DeathRecord"("hospitalId");

-- CreateIndex
CREATE INDEX "DeathRecord_dateOfDeath_idx" ON "DeathRecord"("dateOfDeath");

-- CreateIndex
CREATE INDEX "DeathRecord_certificateNumber_idx" ON "DeathRecord"("certificateNumber");

-- CreateIndex
CREATE INDEX "MarketplaceVendor_hospitalId_idx" ON "MarketplaceVendor"("hospitalId");

-- CreateIndex
CREATE INDEX "MarketplaceVendor_name_idx" ON "MarketplaceVendor"("name");

-- CreateIndex
CREATE INDEX "MarketplaceVendor_verified_idx" ON "MarketplaceVendor"("verified");

-- CreateIndex
CREATE INDEX "MarketplaceProduct_vendorId_idx" ON "MarketplaceProduct"("vendorId");

-- CreateIndex
CREATE INDEX "MarketplaceProduct_name_idx" ON "MarketplaceProduct"("name");

-- CreateIndex
CREATE INDEX "MarketplaceProduct_category_idx" ON "MarketplaceProduct"("category");

-- CreateIndex
CREATE INDEX "MarketplaceProduct_inStock_idx" ON "MarketplaceProduct"("inStock");

-- CreateIndex
CREATE INDEX "MarketplaceProduct_requiredPrescription_idx" ON "MarketplaceProduct"("requiredPrescription");

-- CreateIndex
CREATE UNIQUE INDEX "MarketplaceOrder_reference_key" ON "MarketplaceOrder"("reference");

-- CreateIndex
CREATE INDEX "MarketplaceOrder_patientId_idx" ON "MarketplaceOrder"("patientId");

-- CreateIndex
CREATE INDEX "MarketplaceOrder_reference_idx" ON "MarketplaceOrder"("reference");

-- CreateIndex
CREATE INDEX "MarketplaceOrder_status_idx" ON "MarketplaceOrder"("status");

-- CreateIndex
CREATE INDEX "MarketplaceOrder_createdAt_idx" ON "MarketplaceOrder"("createdAt");

-- CreateIndex
CREATE INDEX "OrderItem_orderId_idx" ON "OrderItem"("orderId");

-- CreateIndex
CREATE INDEX "OrderItem_productId_idx" ON "OrderItem"("productId");

-- CreateIndex
CREATE INDEX "OrderItem_prescriptionId_idx" ON "OrderItem"("prescriptionId");

-- CreateIndex
CREATE INDEX "CartItem_patientId_idx" ON "CartItem"("patientId");

-- CreateIndex
CREATE INDEX "CartItem_productId_idx" ON "CartItem"("productId");

-- CreateIndex
CREATE INDEX "SavedVendor_patientId_idx" ON "SavedVendor"("patientId");

-- CreateIndex
CREATE INDEX "SavedVendor_vendorId_idx" ON "SavedVendor"("vendorId");

-- CreateIndex
CREATE UNIQUE INDEX "SavedVendor_patientId_vendorId_key" ON "SavedVendor"("patientId", "vendorId");

-- CreateIndex
CREATE INDEX "Prescription_patientId_idx" ON "Prescription"("patientId");

-- CreateIndex
CREATE INDEX "Prescription_doctorId_idx" ON "Prescription"("doctorId");

-- CreateIndex
CREATE INDEX "Prescription_hospitalId_idx" ON "Prescription"("hospitalId");

-- CreateIndex
CREATE INDEX "Prescription_validFrom_idx" ON "Prescription"("validFrom");

-- CreateIndex
CREATE INDEX "Prescription_validUntil_idx" ON "Prescription"("validUntil");

-- CreateIndex
CREATE INDEX "Prescription_filledStatus_idx" ON "Prescription"("filledStatus");

-- CreateIndex
CREATE INDEX "_DoctorPatients_B_index" ON "_DoctorPatients"("B");

-- AddForeignKey
ALTER TABLE "AntenatalRecord" ADD CONSTRAINT "AntenatalRecord_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AntenatalRecord" ADD CONSTRAINT "AntenatalRecord_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AntenatalRecord" ADD CONSTRAINT "AntenatalRecord_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AntenatalRecord" ADD CONSTRAINT "AntenatalRecord_updatedByUserId_fkey" FOREIGN KEY ("updatedByUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NeonatalRecord" ADD CONSTRAINT "NeonatalRecord_createdByUserId_fkey" FOREIGN KEY ("createdByUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NeonatalRecord" ADD CONSTRAINT "NeonatalRecord_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NeonatalRecord" ADD CONSTRAINT "NeonatalRecord_motherId_fkey" FOREIGN KEY ("motherId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NeonatalRecord" ADD CONSTRAINT "NeonatalRecord_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "NeonatalRecord" ADD CONSTRAINT "NeonatalRecord_updatedByUserId_fkey" FOREIGN KEY ("updatedByUserId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_resets" ADD CONSTRAINT "password_resets_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "password_resets" ADD CONSTRAINT "password_resets_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "security_audit_logs" ADD CONSTRAINT "security_audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile_pictures" ADD CONSTRAINT "profile_pictures_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profile_pictures" ADD CONSTRAINT "profile_pictures_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_emails" ADD CONSTRAINT "patient_emails_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "patient_phones" ADD CONSTRAINT "patient_phones_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Department" ADD CONSTRAINT "Department_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepartmentMembership" ADD CONSTRAINT "DepartmentMembership_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DepartmentMembership" ADD CONSTRAINT "DepartmentMembership_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StaffProfile" ADD CONSTRAINT "StaffProfile_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StaffProfile" ADD CONSTRAINT "StaffProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientHospitalAccess" ADD CONSTRAINT "PatientHospitalAccess_grantedBy_fkey" FOREIGN KEY ("grantedBy") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientHospitalAccess" ADD CONSTRAINT "PatientHospitalAccess_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientHospitalAccess" ADD CONSTRAINT "PatientHospitalAccess_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientSearchIndex" ADD CONSTRAINT "PatientSearchIndex_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAvailability" ADD CONSTRAINT "DoctorAvailability_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAvailability" ADD CONSTRAINT "DoctorAvailability_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PatientWidgetPreference" ADD CONSTRAINT "PatientWidgetPreference_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Referral" ADD CONSTRAINT "Referral_fromHospitalId_fkey" FOREIGN KEY ("fromHospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Referral" ADD CONSTRAINT "Referral_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Referral" ADD CONSTRAINT "Referral_toHospitalId_fkey" FOREIGN KEY ("toHospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StatusHistory" ADD CONSTRAINT "StatusHistory_referralId_fkey" FOREIGN KEY ("referralId") REFERENCES "Referral"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ambulance" ADD CONSTRAINT "Ambulance_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmbulanceDispatch" ADD CONSTRAINT "AmbulanceDispatch_ambulanceId_fkey" FOREIGN KEY ("ambulanceId") REFERENCES "Ambulance"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmbulanceDispatch" ADD CONSTRAINT "AmbulanceDispatch_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmbulanceDispatch" ADD CONSTRAINT "AmbulanceDispatch_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmbulanceRequest" ADD CONSTRAINT "AmbulanceRequest_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AmbulanceRequest" ADD CONSTRAINT "AmbulanceRequest_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Wallet" ADD CONSTRAINT "Wallet_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WalletTransaction" ADD CONSTRAINT "WalletTransaction_walletId_fkey" FOREIGN KEY ("walletId") REFERENCES "Wallet"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Billing" ADD CONSTRAINT "Billing_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Billing" ADD CONSTRAINT "Billing_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_billingId_fkey" FOREIGN KEY ("billingId") REFERENCES "Billing"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment_transactionId_fkey" FOREIGN KEY ("transactionId") REFERENCES "WalletTransaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Conversation" ADD CONSTRAINT "Conversation_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES "Conversation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Message" ADD CONSTRAINT "Message_senderId_fkey" FOREIGN KEY ("senderId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BirthRecord" ADD CONSTRAINT "BirthRecord_attendingDoctorId_fkey" FOREIGN KEY ("attendingDoctorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BirthRecord" ADD CONSTRAINT "BirthRecord_fatherId_fkey" FOREIGN KEY ("fatherId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BirthRecord" ADD CONSTRAINT "BirthRecord_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BirthRecord" ADD CONSTRAINT "BirthRecord_motherId_fkey" FOREIGN KEY ("motherId") REFERENCES "Patient"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "BirthRecord" ADD CONSTRAINT "BirthRecord_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeathRecord" ADD CONSTRAINT "DeathRecord_attendingDoctorId_fkey" FOREIGN KEY ("attendingDoctorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeathRecord" ADD CONSTRAINT "DeathRecord_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DeathRecord" ADD CONSTRAINT "DeathRecord_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MarketplaceVendor" ADD CONSTRAINT "MarketplaceVendor_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MarketplaceProduct" ADD CONSTRAINT "MarketplaceProduct_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "MarketplaceVendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MarketplaceOrder" ADD CONSTRAINT "MarketplaceOrder_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "MarketplaceOrder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_prescriptionId_fkey" FOREIGN KEY ("prescriptionId") REFERENCES "Prescription"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "MarketplaceProduct"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CartItem" ADD CONSTRAINT "CartItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "MarketplaceProduct"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedVendor" ADD CONSTRAINT "SavedVendor_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SavedVendor" ADD CONSTRAINT "SavedVendor_vendorId_fkey" FOREIGN KEY ("vendorId") REFERENCES "MarketplaceVendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prescription" ADD CONSTRAINT "Prescription_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prescription" ADD CONSTRAINT "Prescription_hospitalId_fkey" FOREIGN KEY ("hospitalId") REFERENCES "Hospital"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Prescription" ADD CONSTRAINT "Prescription_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DoctorPatients" ADD CONSTRAINT "_DoctorPatients_A_fkey" FOREIGN KEY ("A") REFERENCES "Patient"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_DoctorPatients" ADD CONSTRAINT "_DoctorPatients_B_fkey" FOREIGN KEY ("B") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

