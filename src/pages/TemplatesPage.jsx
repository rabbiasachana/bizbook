import React, { useState } from 'react';
import { Chip, Button } from '../components/ui';
import { Cake, Scissors, Shirt, Hammer, Calendar, ArrowRight, Check } from 'lucide-react';
import { Link } from 'react-router-dom';

const templates = [
  {
    id: 'bakery',
    name: 'Custom Bakery & Confectionery',
    category: 'Food & Baking',
    icon: Cake,
    description: 'Designed for cake artists and artisan bakers tracking flavors, servings, tiers, and pickup times.',
    columns: [
      { name: 'Customer & Contact', type: 'text / tel' },
      { name: 'Flavor / Filling', type: 'dropdown' },
      { name: 'Tiers / Servings', type: 'number' },
      { name: 'Due Date / Pickup Slot', type: 'date + time' },
      { name: 'Deposit Paid', type: 'currency' },
      { name: 'Balance Pending', type: 'formula' },
    ],
  },
  {
    id: 'crochet',
    name: 'Crochet & Knitwear Studio',
    category: 'Handmade Crafts',
    icon: Scissors,
    description: 'Perfect for yarn crafters managing custom commissions, yarn costs, and completion milestones.',
    columns: [
      { name: 'Customer', type: 'text' },
      { name: 'Item Pattern / Size', type: 'text' },
      { name: 'Yarn Skein Cost', type: 'currency' },
      { name: 'Labor Hours', type: 'number' },
      { name: 'Stage Status', type: 'stamp chip' },
      { name: 'Total Profit', type: 'formula' },
    ],
  },
  {
    id: 'apparel',
    name: 'Boutique Apparel & Tailoring',
    category: 'Fashion & Textiles',
    icon: Shirt,
    description: 'Track measurements, fabric costs, fitting sessions, and dispatch tracking for bespoke clothing.',
    columns: [
      { name: 'Client Name', type: 'text' },
      { name: 'Measurements Profile', type: 'text / link' },
      { name: 'Fabric & Notions Cost', type: 'currency' },
      { name: 'Trial / Fitting Date', type: 'date' },
      { name: 'Payment Status', type: 'stamp chip' },
      { name: 'Delivery Cost', type: 'currency' },
    ],
  },
  {
    id: 'woodworking',
    name: 'Custom Woodwork & Carpentry',
    category: 'Craftsmanship & Goods',
    icon: Hammer,
    description: 'Built for woodworkers balancing timber, hardware, delivery logistics, and staged deposits.',
    columns: [
      { name: 'Client & Address', type: 'text' },
      { name: 'Wood Species & Dimensions', type: 'text' },
      { name: 'Hardware & Finish Cost', type: 'currency' },
      { name: 'Estimated Completion', type: 'date' },
      { name: 'Deposit Received', type: 'currency' },
      { name: 'Net Margin %', type: 'formula' },
    ],
  },
  {
    id: 'events',
    name: 'Event Decor & Floral Styling',
    category: 'Event Services',
    icon: Calendar,
    description: 'Coordinate floral orders, venue setups, rental equipment, and final balances on event day.',
    columns: [
      { name: 'Event / Host Name', type: 'text' },
      { name: 'Venue Location', type: 'text' },
      { name: 'Event Date & Call Time', type: 'date + time' },
      { name: 'Inventory / Rental Cost', type: 'currency' },
      { name: 'Total Contract Value', type: 'currency' },
      { name: 'Setup Status', type: 'stamp chip' },
    ],
  },
];

export default function TemplatesPage() {
  const [selectedCategory, setSelectedCategory] = useState('All');

  const categories = ['All', 'Food & Baking', 'Handmade Crafts', 'Fashion & Textiles', 'Craftsmanship & Goods', 'Event Services'];

  const filtered = selectedCategory === 'All'
    ? templates
    : templates.filter((t) => t.category === selectedCategory);

  return (
    <div className="max-w-5xl mx-auto space-y-8 py-6">
      {/* Header */}
      <div className="space-y-3">
        <Chip variant="profit">Curated Starter Kits</Chip>
        <h1 className="font-heading text-3xl sm:text-4xl font-bold tracking-tight text-ink">
          Business Sheet Templates
        </h1>
        <p className="text-base sm:text-lg text-ink-muted max-w-2xl">
          Start in seconds with battle-tested ledger templates designed for craft makers, bespoke artisans, and service specialists.
        </p>
      </div>

      {/* Category Pills */}
      <div className="flex flex-wrap gap-2 pt-2">
        {categories.map((cat) => (
          <button
            key={cat}
            onClick={() => setSelectedCategory(cat)}
            className={`min-h-[44px] px-4 py-2 rounded-[8px] text-xs font-semibold transition-colors border ${
              selectedCategory === cat
                ? 'bg-accent text-paper border-accent shadow-subtle'
                : 'bg-surface text-ink-muted border-line hover:text-ink hover:bg-paper'
            }`}
          >
            {cat}
          </button>
        ))}
      </div>

      {/* Template Cards Grid */}
      <div className="grid gap-6 md:grid-cols-2">
        {filtered.map((tmpl) => {
          const Icon = tmpl.icon;
          return (
            <div
              key={tmpl.id}
              className="rounded-[8px] border border-line bg-surface p-6 shadow-subtle flex flex-col justify-between hover:border-accent/40 transition-colors"
            >
              <div className="space-y-4">
                <div className="flex items-start justify-between">
                  <div className="flex h-12 w-12 items-center justify-center rounded-[8px] bg-paper border border-line text-accent">
                    <Icon className="h-6 w-6" />
                  </div>
                  <Chip variant="default">{tmpl.category}</Chip>
                </div>

                <div>
                  <h3 className="font-heading text-xl font-bold text-ink mb-1">
                    {tmpl.name}
                  </h3>
                  <p className="text-sm text-ink-muted">
                    {tmpl.description}
                  </p>
                </div>

                <div className="space-y-2 pt-2 border-t border-line/60">
                  <span className="text-xs font-mono font-semibold uppercase text-ink-muted block">
                    Key Columns Included:
                  </span>
                  <div className="flex flex-wrap gap-1.5">
                    {tmpl.columns.map((col, idx) => (
                      <span
                        key={idx}
                        className="inline-flex items-center gap-1 px-2 py-0.5 rounded-[4px] bg-paper border border-line text-[11px] font-mono text-ink"
                      >
                        <Check className="h-3 w-3 text-profit" />
                        {col.name}
                      </span>
                    ))}
                  </div>
                </div>
              </div>

              <div className="pt-6 mt-4 border-t border-line flex items-center justify-between">
                <span className="text-xs text-ink-muted font-mono">MIT Ready</span>
                <Link to="/app/templates">
                  <Button variant="primary" size="sm">
                    Use Template <ArrowRight className="h-3.5 w-3.5 ml-1" />
                  </Button>
                </Link>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
