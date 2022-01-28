#include <YSI_Coding\y_hooks>

new
    SQL_Connection,
    SQL_Radio_Connection,
    SQL_Buffer[2048];

static
    SQL_Host[64],
    SQL_User[64],
    SQL_Password[64],
    SQL_Database[64];

hook OnGameModeInit() {
    Env_Get("SQL_HOST", SQL_Host);
    Env_Get("SQL_USER", SQL_User);
    Env_Get("SQL_PASSWORD", SQL_Password);
    Env_Get("SQL_DATABASE", SQL_Database);

    SQL_Connection = mysql_connect(SQL_Host, SQL_User, SQL_Database, SQL_Password);

    if(mysql_errno(SQL_Connection)) {
        printf("[ERROR] - Unable to establish a connection with the MySQL server...\nDetails: %s, %s, %s, %s", SQL_Host, SQL_User, SQL_Password, SQL_Database);
        SendRconCommand("exit");
        return 1;
    }

    // SQL_Radio_Connection = mysql_connect(SQL_Host, SQL_User, "shoutcast", SQL_Password);

    // if(mysql_errno(SQL_Radio_Connection)) {
        // SQL_Radio_Connection = 0;
    // }
    SQL_Radio_Connection = 0;

    return 1;
}