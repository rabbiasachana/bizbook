import React, { createContext, useContext, useState, useCallback } from 'react';
import { createPortal } from 'react-dom';
import { X, Undo2 } from 'lucide-react';
import { cn } from '../../lib/utils';

const ToastContext = createContext(null);

export function ToastProvider({ children }) {
  const [toasts, setToasts] = useState([]);

  const addToast = useCallback(({ message, type = 'info', onUndo, duration = 5000 }) => {
    const id = Date.now().toString() + Math.random().toString(36).substring(2, 5);
    const newToast = { id, message, type, onUndo };

    setToasts((prev) => [...prev, newToast]);

    if (duration > 0) {
      setTimeout(() => {
        setToasts((prev) => prev.filter((t) => t.id !== id));
      }, duration);
    }
    return id;
  }, []);

  const removeToast = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id));
  }, []);

  return (
    <ToastContext.Provider value={{ toast: addToast, removeToast }}>
      {children}
      {createPortal(
        <div
          aria-live="polite"
          className="fixed bottom-16 md:bottom-4 right-4 z-50 flex flex-col gap-2 max-w-sm w-full pointer-events-none px-4 sm:px-0"
        >
          {toasts.map((t) => (
            <div
              key={t.id}
              role="alert"
              className={cn(
                'pointer-events-auto flex items-center justify-between gap-3 p-3.5 rounded-[8px] border shadow-dropdown transition-all animate-in slide-in-from-bottom-3 duration-200',
                'bg-surface border-line text-ink'
              )}
            >
              <span className="text-sm font-medium">{t.message}</span>
              <div className="flex items-center gap-1.5 shrink-0">
                {t.onUndo && (
                  <button
                    type="button"
                    onClick={() => {
                      t.onUndo();
                      removeToast(t.id);
                    }}
                    className="inline-flex items-center gap-1 min-h-[36px] px-2.5 text-xs font-semibold rounded-[6px] text-accent hover:bg-accent-subtle transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent"
                  >
                    <Undo2 className="h-3.5 w-3.5" />
                    Undo
                  </button>
                )}
                <button
                  type="button"
                  onClick={() => removeToast(t.id)}
                  aria-label="Dismiss toast"
                  className="flex h-[36px] w-[36px] items-center justify-center rounded-[6px] text-ink-muted hover:text-ink hover:bg-paper transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-accent"
                >
                  <X className="h-4 w-4" />
                </button>
              </div>
            </div>
          ))}
        </div>,
        document.body
      )}
    </ToastContext.Provider>
  );
}

export function useToast() {
  const context = useContext(ToastContext);
  if (!context) {
    throw new Error('useToast must be used within a ToastProvider');
  }
  return context;
}
