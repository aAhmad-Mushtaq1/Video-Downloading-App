#ifndef WIN32_WINDOW_H_
#define WIN32_WINDOW_H_

#include <windows.h>
#include <string>

class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  struct Size {
    unsigned int width;
    unsigned int height;
    Size(unsigned int width, unsigned int height)
        : width(width), height(height) {}
  };

  Win32Window();
  virtual ~Win32Window();

  bool CreateAndShow(const std::wstring& title, const Point& origin,
                     const Size& size);

  void SetQuitOnClose(bool quit_on_close);
  bool OnCreate();
  void OnDestroy();
  void Destroy();

 protected:
  virtual LRESULT MessageHandler(HWND window, UINT const message,
                                 WPARAM const wparam,
                                 LPARAM const lparam) noexcept;

  HWND GetHandle();
  void SetChildContent(HWND content);
  RECT GetClientArea();

 private:
  static LRESULT CALLBACK WndProc(HWND const window, UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  HWND window_handle_ = nullptr;
  bool quit_on_close_ = false;
};

#endif  // WIN32_WINDOW_H_
