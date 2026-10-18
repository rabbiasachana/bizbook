import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import { Topbar } from './Topbar';
import { Sidebar, navItems } from './Sidebar';
import { MobileNav } from './MobileNav';
import { Dialog } from '../ui';
import { NavLink } from 'react-router-dom';
import { cn } from '../../lib/utils';

export function Shell() {
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  return (
    <div className="min-h-screen flex flex-col bg-paper text-ink">
      <Topbar onMobileMenuToggle={() => setIsMobileMenuOpen(true)} />

      <div className="flex flex-1">
        {/* Desktop Sidebar */}
        <Sidebar />

        {/* Mobile Navigation Drawer */}
        <Dialog
          isOpen={isMobileMenuOpen}
          onClose={() => setIsMobileMenuOpen(false)}
          title="All Navigation"
          description="Browse Tallybook pages"
        >
          <div className="grid grid-cols-1 gap-1 py-2 max-h-[60vh] overflow-y-auto">
            {navItems.map((item) => {
              const Icon = item.icon;
              return (
                <NavLink
                  key={item.path}
                  to={item.path}
                  onClick={() => setIsMobileMenuOpen(false)}
                  className={({ isActive }) =>
                    cn(
                      'flex items-center gap-3 px-3 py-2.5 rounded-[8px] text-sm font-medium transition-colors min-h-[44px]',
                      isActive
                        ? 'bg-accent-subtle text-accent-hover font-semibold'
                        : 'text-ink-muted hover:bg-paper hover:text-ink'
                    )
                  }
                >
                  <Icon className="h-4 w-4 shrink-0" />
                  <span>{item.name}</span>
                </NavLink>
              );
            })}
          </div>
        </Dialog>

        {/* Main Content Area */}
        <main className="flex-1 p-4 md:p-6 lg:p-8 pb-20 md:pb-8 overflow-x-hidden">
          <Outlet />
        </main>
      </div>

      {/* Mobile Bottom Tab Bar */}
      <MobileNav />
    </div>
  );
}
