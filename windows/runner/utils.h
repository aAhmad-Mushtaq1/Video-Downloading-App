#ifndef UTILS_H_
#define UTILS_H_

#include <string>
#include <vector>

void CreateAndAttachConsole();
std::vector<std::string> GetCommandLineArguments();
std::wstring Utf16FromUtf8(const std::string& utf8_string);

#endif  // UTILS_H_
