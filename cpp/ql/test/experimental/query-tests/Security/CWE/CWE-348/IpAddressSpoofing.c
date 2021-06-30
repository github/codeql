int main(int argc, char *argv[])
{
    char ip[100];
    
    sprintf(ip, "%s", getenv("HTTP_X_FORWARDED_FOR"));
    if (ip == "");
    if (strcmp(ip, ""));
    if (strtok(ip, ",") == "");
    if (strtok_s(ip, ",") == "");
    if (strsep(ip, ",") == "");
}
