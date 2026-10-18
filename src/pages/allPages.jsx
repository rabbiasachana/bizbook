import React from 'react';
import {
  TableProperties,
  Layers,
  Users,
  LineChart,
  UserCheck,
  History,
  ArrowUpDown,
  ShieldCheck,
  HelpCircle,
  LogIn,
  UserPlus,
  MailCheck,
  KeyRound,
  Compass,
  FileSpreadsheet,
  Search,
} from 'lucide-react';
import { createPlaceholderPage } from './Placeholder';
import { Chip, Button } from '../components/ui';
import { Link } from 'react-router-dom';

// Public Pages
export const HomePage = () => (
  <div className="flex flex-col items-center justify-center min-h-[60vh] text-center px-4 space-y-6">
    <Chip variant="accent">Crafted for Makers & Small Businesses</Chip>
    <h1 className="font-heading text-4xl sm:text-5xl font-bold tracking-tight text-ink max-w-xl">
      Tallybook
    </h1>
    <p className="text-base sm:text-lg text-ink-muted max-w-md">
      The ledger-paper styled workspace for custom orders, automated profit margins, and zero-headache debt tracking.
    </p>
    <div className="flex flex-wrap items-center justify-center gap-3 pt-2">
      <Link to="/app/dashboard">
        <Button variant="primary">Go to Dashboard</Button>
      </Link>
      <Link to="/how-it-works">
        <Button variant="secondary">How It Works</Button>
      </Link>
    </div>
  </div>
);

// Auth & Onboarding Placeholders
export const LoginPage = createPlaceholderPage('Log In', 'Sign in to access your business ledger and orders.', LogIn);
export const RegisterPage = createPlaceholderPage('Create Account', 'Sign up in under 90 seconds to begin managing orders.', UserPlus);
export const VerifyEmailPage = createPlaceholderPage('Verify Email', 'Please check your inbox to confirm your email address.', MailCheck);
export const ForgotPasswordPage = createPlaceholderPage('Forgot Password', 'Request a reset link for your account.', KeyRound);
export const ResetPasswordPage = createPlaceholderPage('Reset Password', 'Enter your new password.', KeyRound);
export const OnboardingPage = createPlaceholderPage('Onboarding Wizard', 'Step 1 of 3: Business name, currency, and order prefix setup.', Compass);

// App Dashboard with Ruled-Paper background
export const DashboardPage = () => (
  <div className="rounded-[8px] border border-line bg-ruled-paper p-6 sm:p-8 min-h-[75vh] flex flex-col justify-between">
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <span className="font-mono text-xs text-ink-muted uppercase tracking-wider block">Overview</span>
          <h1 className="font-heading text-2xl sm:text-3xl font-bold text-ink">Business Dashboard</h1>
        </div>
        <div className="flex gap-2">
          <Chip variant="profit">Current Month: Active</Chip>
          <Chip variant="owed">2 Overdue</Chip>
        </div>
      </div>

      {/* Hero Card Preview: Money Owed */}
      <div className="rounded-[8px] border border-owed/30 bg-surface p-5 shadow-subtle flex flex-col sm:flex-row justify-between sm:items-center gap-4">
        <div className="space-y-1">
          <span className="font-mono text-xs uppercase font-bold text-owed tracking-wider">Hero Metric</span>
          <h2 className="font-heading text-xl font-bold text-ink">Money Owed to You</h2>
          <p className="text-sm text-ink-muted">Quick glance at pending payments from customers.</p>
        </div>
        <div className="text-right sm:text-right">
          <span className="font-heading text-3xl font-bold text-owed tabular-nums">$1,450.00</span>
          <p className="text-xs text-ink-muted">from 4 orders</p>
        </div>
      </div>

      {/* KPI Tiles Preview */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className="p-4 rounded-[8px] border border-line bg-surface shadow-subtle space-y-1">
          <span className="text-xs font-mono text-ink-muted uppercase">Orders</span>
          <div className="font-heading text-2xl font-bold text-ink tabular-nums">28</div>
        </div>
        <div className="p-4 rounded-[8px] border border-line bg-surface shadow-subtle space-y-1">
          <span className="text-xs font-mono text-ink-muted uppercase">Revenue</span>
          <div className="font-heading text-2xl font-bold text-profit tabular-nums">$6,240.00</div>
        </div>
        <div className="p-4 rounded-[8px] border border-line bg-surface shadow-subtle space-y-1">
          <span className="text-xs font-mono text-ink-muted uppercase">Total Cost</span>
          <div className="font-heading text-2xl font-bold text-ink tabular-nums">$2,110.00</div>
        </div>
        <div className="p-4 rounded-[8px] border border-line bg-surface shadow-subtle space-y-1">
          <span className="text-xs font-mono text-ink-muted uppercase">Net Profit</span>
          <div className="font-heading text-2xl font-bold text-profit tabular-nums">$4,130.00</div>
        </div>
      </div>
    </div>

    <div className="mt-8 pt-6 border-t border-line/60 flex flex-col sm:flex-row items-center justify-between text-xs text-ink-muted gap-2">
      <span>Subtle ruled-paper canvas active. Data aggregation will connect in Phase 8.</span>
      <Link to="/app/orders/current" className="text-accent hover:underline font-medium">
        Open Current Sheet &rarr;
      </Link>
    </div>
  </div>
);

// App Route Placeholders
export const OrdersPage = createPlaceholderPage('Orders & Spreadsheet Grid', 'Interactive Glide Data Grid with inline calculation will be enabled in Phase 5.', FileSpreadsheet);
export const SheetDetailPage = createPlaceholderPage('Sheet Details', 'Viewing specific monthly sheet orders and custom columns.', TableProperties);
export const CustomerLedgerPage = createPlaceholderPage('Customer Ledger', 'Auto-compiled list of all customers, orders, and total balances.', Users);
export const AppTemplatesPage = createPlaceholderPage('Manage Business Templates', 'Customize schema, columns, and custom calculation formulas.', Layers);
export const TemplateEditorPage = createPlaceholderPage('Template Editor', 'Add, remove, and configure custom order columns.', Layers);
export const AnalyticsPage = createPlaceholderPage('Analytics & Reports', 'Month-over-month performance, margin alerts, and cost breakdowns.', LineChart);
export const EmployeesPage = createPlaceholderPage('Team & Permissions', 'Manage employees and granular access control.', UserCheck);
export const ActivityPage = createPlaceholderPage('Activity History', 'Audit log of orders created, updated, and deleted.', History);
export const ImportExportPage = createPlaceholderPage('Import & Export', 'Import from Excel/CSV or export PDF receipts and reports.', ArrowUpDown);
export const SecurityPage = createPlaceholderPage('Security & Devices', 'Active sessions, trusted devices, and local lock PIN.', ShieldCheck);
export const SearchPage = createPlaceholderPage('Global Search', 'Quick search orders, customers, and sheets.', Search);
export const ProfilePage = createPlaceholderPage('Business Profile', 'Update business branding, logo, contacts, and default settings.', Users);
export const HelpPage = createPlaceholderPage('Help & Shortcuts', 'Guides, formula references, and keyboard shortcuts cheat-sheet.', HelpCircle);
export const NotFoundPage = createPlaceholderPage('404 - Not Found', 'The requested page does not exist.', HelpCircle);
