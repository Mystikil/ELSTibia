#include "otpch.h"

#ifdef ENABLE_PYTHON
#include "pythonscript.h"

PythonScriptInterface g_pythonEnvironment;

PythonScriptInterface::PythonScriptInterface()
{
    Py_Initialize();
}

PythonScriptInterface::~PythonScriptInterface()
{
    Py_FinalizeEx();
}

bool PythonScriptInterface::init()
{
    return Py_IsInitialized();
}

bool PythonScriptInterface::loadFile(const std::string& file)
{
    std::string fullPath = scriptsPath + file;
    FILE* f = fopen(fullPath.c_str(), "r");
    if (!f) {
        return false;
    }
    int res = PyRun_SimpleFile(f, fullPath.c_str());
    fclose(f);
    return res == 0;
}

#endif // ENABLE_PYTHON
