#ifndef RUN_LOOP_H_
#define RUN_LOOP_H_

class RunLoop {
 public:
  RunLoop();
  ~RunLoop();
  void Run();
  void Quit();

 private:
  bool running_ = false;
};

#endif  // RUN_LOOP_H_
