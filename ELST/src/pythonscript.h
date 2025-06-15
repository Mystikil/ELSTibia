#ifndef FS_PYTHONSCRIPT_H
#define FS_PYTHONSCRIPT_H

#ifdef ENABLE_PYTHON
#include <Python.h>

class PythonScriptInterface
{
public:
    PythonScriptInterface();
    ~PythonScriptInterface();

    bool init();
    bool loadFile(const std::string& file);

private:
    std::string scriptsPath = "data/python/";
};

#endif // ENABLE_PYTHON

#endif // FS_PYTHONSCRIPT_H
extern PythonScriptInterface g_pythonEnvironment;
