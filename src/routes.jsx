import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { Shell } from './components/layout';
import HowItWorksPage from './pages/HowItWorksPage';
import TemplatesPage from './pages/TemplatesPage';
import {
  HomePage,
  LoginPage,
  RegisterPage,
  VerifyEmailPage,
  ForgotPasswordPage,
  ResetPasswordPage,
  OnboardingPage,
  DashboardPage,
  OrdersPage,
  SheetDetailPage,
  CustomerLedgerPage,
  AppTemplatesPage,
  TemplateEditorPage,
  AnalyticsPage,
  EmployeesPage,
  ActivityPage,
  ImportExportPage,
  SecurityPage,
  SearchPage,
  ProfilePage,
  HelpPage,
  NotFoundPage,
} from './pages/allPages';

export function AppRoutes() {
  return (
    <Routes>
      {/* Public Pages */}
      <Route path="/" element={<HomePage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/register" element={<RegisterPage />} />
      <Route path="/verify-email" element={<VerifyEmailPage />} />
      <Route path="/forgot-password" element={<ForgotPasswordPage />} />
      <Route path="/reset-password" element={<ResetPasswordPage />} />
      <Route path="/onboarding" element={<OnboardingPage />} />
      <Route path="/how-it-works" element={<HowItWorksPage />} />
      <Route path="/templates" element={<TemplatesPage />} />

      {/* App Shell Routes */}
      <Route path="/app" element={<Shell />}>
        <Route index element={<Navigate to="/app/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardPage />} />
        <Route path="orders" element={<OrdersPage />} />
        <Route path="orders/:sheetId" element={<SheetDetailPage />} />
        <Route path="customers" element={<CustomerLedgerPage />} />
        <Route path="templates" element={<AppTemplatesPage />} />
        <Route path="templates/new" element={<TemplateEditorPage />} />
        <Route path="templates/:id/edit" element={<TemplateEditorPage />} />
        <Route path="analytics" element={<AnalyticsPage />} />
        <Route path="employees" element={<EmployeesPage />} />
        <Route path="activity" element={<ActivityPage />} />
        <Route path="import-export" element={<ImportExportPage />} />
        <Route path="security" element={<SecurityPage />} />
        <Route path="search" element={<SearchPage />} />
        <Route path="profile" element={<ProfilePage />} />
        <Route path="help" element={<HelpPage />} />
      </Route>

      {/* 404 Catch All */}
      <Route path="*" element={<NotFoundPage />} />
    </Routes>
  );
}

