#include "run_loop.h"
#include <windows.h>

RunLoop::RunLoop() {}
RunLoop::~RunLoop() {}

void RunLoop::Run() {
  running_ = true;

  MSG msg;
  while (running_ && GetMessage(&msg, nullptr, 0, 0)) {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
}

void RunLoop::Quit() {
  running_ = false;
  PostQuitMessage(0);
}
