#include <string>

#include "cn_uid_dpi.h"

#include "svdpi.h"

static svScope cn_uid_scope;

extern "C" void set_scope_cn_uid_dpi()
{
   cn_uid_scope = svGetScope();
}

extern "C" int cn_uid_get_id_dpi(const char *_prefix);

int cn_uid_get_id(string _prefix)
{
   svSetScope(cn_uid_scope);
   return cn_uid_get_id_dpi(_prefix.c_str());
}
