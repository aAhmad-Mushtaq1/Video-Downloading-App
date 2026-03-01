#include "win32_window.h"
#include <flutter/flutter_view_controller.h>

Win32Window::Win32Window() {}
Win32Window::~Win32Window() { Destroy(); }

void Win32Window::Destroy() {
  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }
}

bool Win32Window::CreateAndShow(const std::wstring& title, const Point& origin,
                                 const Size& size) {
  const wchar_t* window_class = L"FLUTTER_RUNNER_WIN32_WINDOW";

  WNDCLASS window_class_def = {};
  window_class_def.hCursor = LoadCursor(nullptr, IDC_ARROW);
  window_class_def.lpszClassName = window_class;
  window_class_def.style = CS_HREDRAW | CS_VREDRAW;
  window_class_def.cbClsExtra = 0;
  window_class_def.cbWndExtra = 0;
  window_class_def.hInstance = GetModuleHandle(nullptr);
  window_class_def.hIcon = nullptr;
  window_class_def.hbrBackground = 0;
  window_class_def.lpszMenuName = nullptr;
  window_class_def.lpfnWndProc = WndProc;
  RegisterClass(&window_class_def);

  auto window = CreateWindow(window_class, title.c_str(),
                              WS_OVERLAPPEDWINDOW | WS_VISIBLE, origin.x,
                              origin.y, size.width, size.height, nullptr,
                              nullptr, GetModuleHandle(nullptr), this);

  if (!window) {
    return false;
  }

  return OnCreate();
}

void Win32Window::SetQuitOnClose(bool quit_on_close) {
  quit_on_close_ = quit_on_close;
}

bool Win32Window::OnCreate() { return true; }
void Win32Window::OnDestroy() {
  if (quit_on_close_) {
    PostQuitMessage(0);
  }
}

LRESULT Win32Window::MessageHandler(HWND hwnd, UINT const message,
                                     WPARAM const wparam,
                                     LPARAM const lparam) noexcept {
  return DefWindowProc(hwnd, message, wparam, lparam);
}

LRESULT CALLBACK Win32Window::WndProc(HWND const window, UINT const message,
                                       WPARAM const wparam,
                                       LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto cs = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                     reinterpret_cast<LONG_PTR>(cs->lpCreateParams));
    auto that = static_cast<Win32Window*>(cs->lpCreateParams);
    that->window_handle_ = window;
  } else if (Win32Window* that = reinterpret_cast<Win32Window*>(
                 GetWindowLongPtr(window, GWLP_USERDATA))) {
    return that->MessageHandler(window, message, wparam, lparam);
  }

  return DefWindowProc(window, message, wparam, lparam);
}

HWND Win32Window::GetHandle() { return window_handle_; }

void Win32Window::SetChildContent(HWND content) {
  if (content != nullptr) {
    SetParent(content, window_handle_);
    RECT frame = GetClientArea();
    MoveWindow(content, frame.left, frame.top, frame.right - frame.left,
               frame.bottom - frame.top, true);
    SetFocus(content);
  }
}

RECT Win32Window::GetClientArea() {
  RECT frame;
  GetClientRect(window_handle_, &frame);
  return frame;
}
