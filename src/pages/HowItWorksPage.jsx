import React from 'react';
import { Chip } from '../components/ui';
import { Calculator, Keyboard, ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';

export default function HowItWorksPage() {
  return (
    <div className="max-w-4xl mx-auto space-y-10 py-6">
      {/* Hero Header */}
      <div className="space-y-3">
        <Chip variant="accent">Guide & Workflow</Chip>
        <h1 className="font-heading text-3xl sm:text-4xl font-bold tracking-tight text-ink">
          How Tallybook Works
        </h1>
        <p className="text-base sm:text-lg text-ink-muted max-w-2xl">
          A streamlined, ledger-inspired workspace designed specifically for custom makers, bakers, and small businesses who need fast order tracking, crystal clear margins, and zero accounting headaches.
        </p>
      </div>

      {/* Step by step guide */}
      <div className="space-y-6">
        <h2 className="font-heading text-2xl font-bold text-ink">
          4 Steps to Running Your Business
        </h2>
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="rounded-[8px] border border-line bg-surface p-5 shadow-subtle space-y-2">
            <div className="flex items-center gap-2 font-mono text-xs font-bold uppercase tracking-wider text-accent">
              <span>Step 01</span>
            </div>
            <h3 className="font-heading text-lg font-bold text-ink">Create Your Business</h3>
            <p className="text-sm text-ink-muted">
              Complete the quick 90-second onboarding. Pick your currency, order numbering prefix (e.g., <code className="bg-paper px-1 rounded text-ink">HH-0001</code>), and core business category.
            </p>
          </div>

          <div className="rounded-[8px] border border-line bg-surface p-5 shadow-subtle space-y-2">
            <div className="flex items-center gap-2 font-mono text-xs font-bold uppercase tracking-wider text-accent">
              <span>Step 02</span>
            </div>
            <h3 className="font-heading text-lg font-bold text-ink">Pick or Build a Sheet Template</h3>
            <p className="text-sm text-ink-muted">
              Select pre-tailored columns for your craft (Bakery, Crochet, Apparel, Carpentry, Events) or customize columns with formula and currency fields.
            </p>
          </div>

          <div className="rounded-[8px] border border-line bg-surface p-5 shadow-subtle space-y-2">
            <div className="flex items-center gap-2 font-mono text-xs font-bold uppercase tracking-wider text-accent">
              <span>Step 03</span>
            </div>
            <h3 className="font-heading text-lg font-bold text-ink">Log Orders in Seconds</h3>
            <p className="text-sm text-ink-muted">
              Use the high-speed spreadsheet grid or hit <kbd className="border border-line bg-paper px-1.5 py-0.5 rounded text-xs font-mono">⌘K</kbd> Quick Add. Costs and profit margins calculate instantly.
            </p>
          </div>

          <div className="rounded-[8px] border border-line bg-surface p-5 shadow-subtle space-y-2">
            <div className="flex items-center gap-2 font-mono text-xs font-bold uppercase tracking-wider text-accent">
              <span>Step 04</span>
            </div>
            <h3 className="font-heading text-lg font-bold text-ink">Track Debts & Month Rollover</h3>
            <p className="text-sm text-ink-muted">
              Monitor overdue payments via the Money Owed hero card, send WhatsApp reminders with one click, and roll over to next month seamlessly.
            </p>
          </div>
        </div>
      </div>

      {/* Built-in Safe Formulas */}
      <div className="space-y-4 rounded-[8px] border border-line bg-surface p-6 shadow-subtle">
        <div className="flex items-center gap-2 text-profit">
          <Calculator className="h-5 w-5" />
          <h2 className="font-heading text-xl font-bold text-ink">Standard Business Formulas</h2>
        </div>
        <p className="text-sm text-ink-muted">
          All financial calculations are computed client-side for zero latency and verified by database triggers for ironclad consistency:
        </p>
        <div className="grid gap-3 sm:grid-cols-3 font-mono text-xs">
          <div className="p-3 bg-paper rounded-[8px] border border-line">
            <span className="text-ink-muted block text-[11px] mb-1 font-sans">Total Cost</span>
            <code className="text-ink font-bold">material + delivery + other</code>
          </div>
          <div className="p-3 bg-paper rounded-[8px] border border-line">
            <span className="text-ink-muted block text-[11px] mb-1 font-sans">Net Profit</span>
            <code className="text-profit font-bold">selling_price - total_cost</code>
          </div>
          <div className="p-3 bg-paper rounded-[8px] border border-line">
            <span className="text-ink-muted block text-[11px] mb-1 font-sans">Pending Balance</span>
            <code className="text-owed font-bold">selling_price - paid_amount</code>
          </div>
        </div>
      </div>

      {/* Keyboard Shortcuts */}
      <div className="space-y-4 rounded-[8px] border border-line bg-surface p-6 shadow-subtle">
        <div className="flex items-center gap-2 text-accent">
          <Keyboard className="h-5 w-5" />
          <h2 className="font-heading text-xl font-bold text-ink">Power Keyboard Shortcuts</h2>
        </div>
        <div className="grid gap-3 sm:grid-cols-2 text-sm">
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Open Command Palette / Quick Add</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">⌘ / Ctrl + K</kbd>
          </div>
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Force Save Changes</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">⌘ / Ctrl + S</kbd>
          </div>
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Undo Last Edit</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">⌘ / Ctrl + Z</kbd>
          </div>
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Redo Edit</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">⌘ / Ctrl + Shift + Z</kbd>
          </div>
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Search in Current Sheet</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">⌘ / Ctrl + F</kbd>
          </div>
          <div className="flex justify-between items-center py-2 border-b border-line">
            <span className="text-ink-muted">Show Shortcuts Cheat-sheet</span>
            <kbd className="px-2 py-1 bg-paper border border-line rounded text-xs font-mono text-ink">?</kbd>
          </div>
        </div>
      </div>

      <div className="flex justify-between items-center pt-4">
        <Link
          to="/templates"
          className="inline-flex items-center gap-2 text-sm font-semibold text-accent hover:text-accent-hover transition-colors"
        >
          Explore Ready-made Templates <ArrowRight className="h-4 w-4" />
        </Link>
        <Link
          to="/app/dashboard"
          className="inline-flex items-center gap-2 text-sm font-semibold text-ink-muted hover:text-ink transition-colors"
        >
          Go to Dashboard
        </Link>
      </div>
    </div>
  );
}
