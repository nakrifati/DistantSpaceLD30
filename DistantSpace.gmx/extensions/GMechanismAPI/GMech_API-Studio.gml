#define GMech_Account_LoggedIn
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if string(global.__gmech_username)<>"" then return 1 else return 0;
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        global.__gmech_system_status=5
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Account_Login
__user=string(argument0)
__password=string(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if string_lettersdigits(__user)==string(__user)
        {
            if string(__password)<>""
            {
                if GMech_Account_LoggedIn()=false
                {
                    //Send request to server
                    http_post_string(string(global.__gmech_api_url)+"api_account_login.php","token="+string(global.__gmech_api_token)+"&user="+string(__user)+"&password="+string(__password))
                }
                else
                {
                    global.__gmech_error_system=3
                    global.__gmech_error_spec=7
                }
            }
            else
            {
                global.__gmech_error_system=3
                global.__gmech_error_spec=4
                global.__gmech_system_status=4
            }
        }
        else
        {
            global.__gmech_error_system=3
            global.__gmech_error_spec=3
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        global.__gmech_system_status=5
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Account_Logout
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            //Send logout
            http_post_string(string(global.__gmech_api_url)+"api_account_logout.php","token="+string(global.__gmech_api_token)+"&user="+string(global.__gmech_username))
            global.__gmech_username=""
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        global.__gmech_system_status=5
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Account_SignUp
__user=string(argument0)
__password=string(argument1)
__firstname=string(argument2)
__lastname=string(argument3)
__email=string(argument4)
__website=string(argument5)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if string_lettersdigits(__user)==string(__user)
        {
            if string(__password)<>""
            {
                if string_length(__user)>2 and string_length(__user)<25
                {
                    //Send request to server
                    http_post_string(string(global.__gmech_api_url)+"api_account_signup.php","token="+string(global.__gmech_api_token)+"&user="+string(__user)+"&password="+string(__password)+"&firstname="+string(__firstname)+"&lastname="+string(__lastname)+"&email="+string(__email)+"&website="+string(__website))
                }
                else
                {
                    global.__gmech_error_system=3
                    global.__gmech_error_spec=5
                    global.__gmech_system_status=5
                }
            }
            else
            {
                global.__gmech_error_system=3
                global.__gmech_error_spec=4
                global.__gmech_system_status=4
            }
        }
        else
        {
            global.__gmech_error_system=3
            global.__gmech_error_spec=3
            global.__gmech_system_status=8
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        global.__gmech_system_status=5
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Account_Username
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        return string(global.__gmech_username)
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        global.__gmech_system_status=5
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Ach_Count
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        return real(ds_map_size(global.__gmech_achievement_game))
    }
}
else
{
    return "APINotReady"
}

#define GMech_Ach_Has
__achID=argument0
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __achID>0 and ((__achID>3 and global.__gmech_api_t3=1) or (__achID<=3))
        {
            //Our table is within legal bounds
            //Extract the username from the map
            __ret=string(ds_map_find_value(global.__gmech_achievement_user,"ach"+string(__achID)))
            if string(__ret)="got"
            {
                return 1
            }
            else
            {
                return 0
            }
        }
        else
        {
            return "InvalidAchID"
        }
    }
    else
    {
        return "TokenNotRegistered"
    }
}
else
{
    return "APINotReady"
}

#define GMech_Ach_Submit
__achID=argument0
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __achID>0 and ((__achID>3 and global.__gmech_api_t3=1) or (__achID<=3))
        {
            if GMech_Account_LoggedIn()
            {
                //Our table is within legal bounds
                //Extract the username from the map
                //__ret=string(ds_map_find_value(global.__gmech_achievement_game,"ach"+string(__achID)))
                ds_map_add(global.__gmech_achievement_user,"ach"+string(__achID),"got")
                http_post_string(string(global.__gmech_api_url)+"api_submit_ach.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username())+"&id="+string(__achID)+"&checksum="+string(global.__gmech_checksum))
            }
            else
            {
                global.__gmech_error_system=3
                global.__gmech_error_spec=8
            }
        }
        else
        {
            global.__gmech_error_system=4 //Not allowed
            global.__gmech_error_spec=0
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Ach_Title
__achID=argument0
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __achID>0 and ((__achID>3 and global.__gmech_api_t3=1) or (__achID<=3))
        {
            //Our table is within legal bounds
            //Extract the username from the map
            __ret=string(ds_map_find_value(global.__gmech_achievement_game,"ach"+string(__achID)))
            if string(__ret)<>"0"
            {
                return string(__ret)
            }
            else
            {
                return "N/A"
            }
        }
        else
        {
            return "InvalidAchID"
        }
    }
    else
    {
        return "TokenNotRegistered"
    }
}
else
{
    return "APINotReady"
}

#define GMech_Avatar
__user=string_lower(argument0)
if string(__user)<>""
{
    //If the user is in the map, return the index. Otherwise, request the index from the server and return default
    __ret=string(ds_map_find_value(global.__gmech_avatar_array,string(__user)))
    if string(__ret)<>"0"
    {
        //User is in the array
        if sprite_exists(real(__ret)) then return real(__ret) else return real(global.__gmech_default_avatar)
    }
    else
    {
        //request
        if ds_list_find_index(global.__gmech_noavatar_array,string(__user))=(-1)
        {
            http_post_string(string(global.__gmech_api_url)+"api_check_avatar.php","user="+string(__user))
        }
        return real(global.__gmech_default_avatar)
    }
}


#define GMech_Backend_GMLtoPHP_Datetime
__gmldatetime=argument0 //Format: numerical. Going to: Mmm Dd, YYYY HH:MM:SS
if string(__gmldatetime)<>""
{
    if string_letters(__gmldatetime)=""
    {
        //Get indiv components of the datetime and reiterate
        __month=date_get_month(__gmldatetime)
        __day=date_get_day(__gmldatetime)
        __year=date_get_year(__gmldatetime)
        __hour=date_get_hour(__gmldatetime)
        __minute=date_get_minute(__gmldatetime)
        __second=date_get_second(__gmldatetime)
        
        //Make month  = Mmm, and make seconds/minutes/hours go from h to hh
        if string(__month)="1" then __month="Jan"
        if string(__month)="2" then __month="Feb"
        if string(__month)="3" then __month="Mar"
        if string(__month)="4" then __month="Apr"
        if string(__month)="5" then __month="May"
        if string(__month)="6" then __month="Jun"
        if string(__month)="7" then __month="Jul"
        if string(__month)="8" then __month="Aug"
        if string(__month)="9" then __month="Sep"
        if string(__month)="10" then __month="Oct"
        if string(__month)="11" then __month="Nov"
        if string(__month)="12" then __month="Dec"
        
        if string_length(string(__hour))=1 {__hour="0"+string(__hour)}
        if string_length(string(__minute))=1 {__minute="0"+string(__minute)}
        if string_length(string(__second))=1 {__second="0"+string(__second)}
        
        return string(__month)+" "+string(__day)+", "+string(__year)+" "+string(__hour)+":"+string(__minute)+":"+string(__second)
    }
    else
    {
        return string(__gmldatetime);
    }
}
else
{
    return "";
}

#define GMech_Backend_PHPtoGML_Datetime
//Creates a GML datetime for a PHP datetime as structured by: Mmm dd, YYYY hh:mm:ss
//Note 24-hour format on all operation
//Note that the user might be dumb enough to supply something unexpected, so make sure it follows the pattern
__phpdatetime=string(argument0)
if __phpdatetime<>"" and string_count(" ",__phpdatetime)=3 and string_count(",",__phpdatetime)=1 and string_count(":",__phpdatetime)=2
{
    //Our datetime is proper. Divide date and time
    //__phpdate=string_copy(__phpdatetime,1,13) //Mmm dd, yyyy (possible space after yyyy
    //__phptime=string_replace(__phpdatetime,__phpdate,"")
    //__phptime=string_replace_all(__phptime," ","") //hh:mm:ss
    
    __phptime=string_copy(__phpdatetime,string_length(__phpdatetime)-8,9)
    __phpdate=string_replace(__phpdatetime,string(__phptime),"")
    __hour=string_copy(__phptime,1,string_pos(":",__phptime))
    __hour=string_replace(__hour,":","")
    __phptime=string_replace(__phptime,__hour+":","")
    __minute=string_copy(__phptime,1,string_pos(":",__phptime))
    __minute=string_replace(__minute,":","")
    __phptime=string_replace(__phptime,__minute+":","")
    __second=string(__phptime)
    //Done with time
    __month=string_copy(__phpdate,1,3)
    __month=string_replace(__month," ","")
    __phpdate=string_replace(__phpdate,__month+" ","")
    __day=string_copy(__phpdate,1,string_pos(",",__phpdate))
    __day=string_replace(__day,",","")
    __day=string_replace(__day," ","")
    __phpdate=string_replace(__phpdate,__day+", ","")
    __year=string_replace(__phpdate," ","")
    if __month="Jan" then __month="1"
    if __month="Feb" then __month="2"
    if __month="Mar" then __month="3"
    if __month="Apr" then __month="4"
    if __month="May" then __month="5"
    if __month="Jun" then __month="6"
    if __month="Jul" then __month="7"
    if __month="Aug" then __month="8"
    if __month="Sep" then __month="9"
    if __month="Oct" then __month="10"
    if __month="Nov" then __month="11"
    if __month="Dec" then __month="12"
    __newDT=date_create_datetime(real(__year),real(__month),real(__day),real(__hour),real(__minute),real(__second))
    //show_debug_message("DEBUG: "+string(__year)+" "+string(__month)+" "+string(__day)+" "+string(__hour)+" "+string(__minute)+" "+string(__second))
    return real(__newDT)
}
else
{
    show_debug_message("GMechAPI: ERROR: PHP Datetime supplied is in illegal format!")
}


#define GMech_Chat_Line
__room=real(argument0)
__slot=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t5=1
        {
            //Echo the line
            if __slot>0 and __slot<=30 and __room>0 and __room<1000
            {
                //1 is newest, 30 is oldest
                return string(global.__gmech_chat_line[__room,__slot])
            }
            else
            {
                return string("SlotID/RoomID out of bounds.")
            }
        }
        else
        {
            return "Please upgrade your API license at www.gmechanism.com"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "Please register this game at www.gmechanism.com"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechanism API is not yet ready!"
}

#define GMech_Chat_Reset
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t5=1
        {
            //Reset the arrays
            for (k=0;k<=1000;k+=1) {for (i=0;i<=30; i+=1) {global.__gmech_chat_line[k,i]=""; global.__gmech_chat_timestamp[k,i]="";}} //1 is most recent, 30 last
        }
        else
        {
            return "Please upgrade your API license at www.gmechanism.com"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "Please register this game at www.gmechanism.com"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechanism API is not yet ready!"
}

#define GMech_Chat_Submit
__room=real(argument0)
__text=string(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t5=1
        {
            //Echo the line
            if __room>0 and __room<1000
            {
                if GMech_Account_LoggedIn()
                {
                    http_post_string(string(global.__gmech_api_url)+"api_chat_submit.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username())+"&text="+string(__text)+"&room="+string(__room)+"&checksum="+string(global.__gmech_checksum))
                    global.__gmech_object_id.__chatUpdate=__room
                }
            }
            else
            {
                return string("SlotID/RoomID out of bounds.")
            }
        }
        else
        {
            return "Please upgrade your API license at www.gmechanism.com"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "Please register this game at www.gmechanism.com"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechanism API is not yet ready!"
}

#define GMech_Chat_Timestamp
__room=real(argument0)
__slot=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t5=1
        {
            //Echo the line
            if __slot>0 and __slot<=30 and __room>0 and __room<1000
            {
                //1 is newest, 30 is oldest
                return string(global.__gmech_chat_timestamp[__room,__slot])
            }
            else
            {
                return string("SlotID/RoomID out of bounds.")
            }
        }
        else
        {
            return "Please upgrade your API license at www.gmechanism.com"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "Please register this game at www.gmechanism.com"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechanism API is not yet ready!"
}

#define GMech_Chat_Update
__room=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t5=1
        {
            //Echo the line
            if __room>0 and __room<1000
            {
                //Updating our room... First, let's see what our latest timestamp was
                latest=""
                /*
                for(i=0;i<=30;i+=1)
                {
                    if global.__gmech_chat_timestamp[__room,i]<>"" then latest=string(global.__gmech_chat_timestamp[__room,i])
                }
                */
                latest=string(global.__gmech_chat_timestamp[__room,1])
                //We have our latest (the limiter)
                http_post_string(string(global.__gmech_api_url)+"api_chat_get.php","token="+string(global.__gmech_api_token)+"&limiter="+string(latest)+"&room="+string(__room))
            }
            else
            {
                show_debug_message("SlotID/RoomID out of bounds.")
            }
        }
        else
        {
            show_debug_message("Please upgrade your API license at www.gmechanism.com")
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        show_debug_message("Please register this game at www.gmechanism.com")
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    show_debug_message("GMechanism API is not yet ready!")
}

#define GMech_Error_Clear
global.__gmech_error_system=0
global.__gmech_error_spec=0

#define GMech_Error_Debugging
global.__gmech_error_debugging=argument0
if (argument0)
{
    //Open the log and append a new line
    __f=file_text_open_append("GMech_Log.txt")
    file_text_write_string(__f,string(date_datetime_string(date_current_datetime()))+" ----- SESSION BEGIN -----")
    file_text_writeln(__f)
    file_text_close(__f)
}

#define GMech_Error_Desc
__system=argument0
__spec=argument1
switch(__system)
{
    case 1: //Primary system
        switch(__spec)
        {
            case (-1):
                return "An internal server error ocurred.";
            break;
            case 0:
                return "Game token is not registered on www.gmechanism.com.";
            break;
            case 2:
                return "GMech Object inactive/doesn't exist.";
            break;
            case 3:
                return "No Internet connection found.";
            break;
            case 4:
                return "API not ready.";
            break;
        }
    break;
    case 2: //Highscores
        switch(__spec)
        {
            case 0:
                return "Scoreboard does not exist. Submit score to create board.";
            break;
            case 1:
                return "Scoreboard TableID not within acceptable range. Please upgrade your license at www.gmechanism.com.";
            break;
            case 2:
                return "Scoreboard type is incorrect.";
            break;
            case 3:
                return "Scoreboard reversed flag is incorrect.";
            break;
            case 4:
                return "Scoreboard SlotID is incorrect.";
            break;
        }
    break;
    case 3: //Account
        switch(__spec)
        {
            case 0:
                return "User does not exist."
            break;
            case 1:
                return "Username or password is incorrect."
            break;
            case 2:
                return "User is banned."
            break;
            case 3:
                return "Username can only contain letters and digits."
            break;
            case 4:
                return "Information is missing. No blank usernames, passwords, etc."
            break;
            case 5:
                return "Your username can only be between 3 and 24 characters long."
            break;
            case 6:
                return "Username has already been taken."
            break;
            case 7:
                return "User is already logged in!";
            break;
            case 8:
                return "User isn't logged in!";
            break;
        }
    break;
    case 4: //Ach
        switch(__spec)
        {
            case 0:
                return "Achievement ID is not within acceptable range. Please upgrade your license at www.gmechanism.com.";
            break;
        }
    break;
    case 5: //INI
        switch(__spec)
        {
            case 0:
                return "INI is not part of your license. Please upgrade at www.gmechanism.com.";
            break;
            case 1:
                return "String is more than 2048 characters long. Break it up!";
            break;
            case 2:
                return "INI Section/Variable cannot be blank!";
            break;
            case 3:
                return "User is not logged in.";
            break;
        }
    break;
}
return "";

#define GMech_Error_Spec
return global.__gmech_error_spec;

#define GMech_Error_System
return global.__gmech_error_system;

#define GMech_HS_Count
if is_real(global.__gmech_highscore_count[argument0])
{
    return global.__gmech_highscore_count[argument0]
}
else
{
    return (-1)
}

#define GMech_HS_Rank
__tableID=argument0
__user=string_lower(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                __endRank=0;
                for(__i=0;__i<=GMech_HS_Count(__tableID);__i+=1)
                {
                    //Search for the user
                    if string_lower(ds_map_find_value(global.__gmech_highscore_user,string(__tableID)+"|"+string(__i)))=string(__user)
                    {
                        //We found him! Cancel the loop
                        __endRank=__i
                        break;
                    }
                }
                return __endRank;
            }
            else
            {
                global.__gmech_error_system=2
                global.__gmech_error_spec=4
                return "InvalidSlotID"
            }
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
            return "InvalidTableID"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "TokenNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "APINotReady"
}

#define GMech_HS_Score
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
             {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_highscore_score,string(__tableID)+"|"+string(__slotID)))
                return real(__ret)
            }
            else
            {
                 global.__gmech_error_system=2
                 global.__gmech_error_spec=4
            } 
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_HS_Submit
__tableID=argument0
__user=argument1 //token, table, user, score, type
__score=argument2
__type=argument3
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __type>0 and __type<4
            {
                //Good to go
                if GMech_Account_LoggedIn()
                {
                    __userToUse=string_lettersdigits(GMech_Account_Username())
                }
                else
                {
                    if string_lettersdigits(__user)<>""
                    {
                        __userToUse=string_lettersdigits(__user)
                    }
                    else
                    {
                        __userToUse="guest"+string(round(random_range(100,99999)))
                    }
                }
                if GMech_Account_LoggedIn() then __check=string(global.__gmech_checksum) else __check="guest"
                http_post_string(string(global.__gmech_api_url)+"api_submit_highscore.php","token="+string(global.__gmech_api_token)+"&table="+string(__tableID)+"&user="+string(__userToUse)+"&score="+string(__score)+"&type="+string(__type)+"&checksum="+string(__check))
            }
            else
            {
                show_debug_message("GMechAPI: ERROR: Invalid table type. See documentation.")
            }
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_HS_Timestamp
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_highscore_timestamp,string(__tableID)+"|"+string(__slotID)))
                if string(__ret)<>"0"
                {
                    return string(__ret)
                }
                else
                {
                    return "N/A"
                }
            }
            else
            {
                return "InvalidSlotID"
            }
        }
        else
        {
            return "InvalidTableID"
        }
    }
    else
    {
        return "TokenNotRegistered"
    }
}
else
{
    return "APINotReady";
}

#define GMech_HS_User
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_highscore_user,string(__tableID)+"|"+string(__slotID)))
                if string(__ret)<>"0"
                {
                     return string(__ret)
                }
                else
                {
                     return "N/A"
                }
            }
            else
            {
                global.__gmech_error_system=2
                global.__gmech_error_spec=4
                return "InvalidSlotID"
            }
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
            return "InvalidTableID"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "TokenNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "APINotReady"
}

#define GMech_INI_Key_Exists
__section=string_lower(argument0)
__key=string_lower(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_remote.ini")
            __res=ini_key_exists(__section,__key)
            ini_close()
            return __res;
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return false;
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return false;
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return false;
}

#define GMech_INI_Read_Real
__section=string_lower(argument0)
__variable=string_lower(argument1)
__def=real(argument2)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            if file_exists("gmech_remote.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_remote.ini")
                __res=ini_read_real(__section,__variable,__def)
                ini_close()
                return real(__res)
            }
            else
            {
                return real(__def)
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return real(__def)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return real(__def)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return real(__def)
}

#define GMech_INI_Read_String
__section=string_lower(argument0)
__variable=string_lower(argument1)
__def=string(argument2)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            if file_exists("gmech_remote.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_remote.ini")
                __res=ini_read_string(__section,__variable,__def)
                ini_close()
                return string(__res)
            }
            else
            {
                return string(__def)
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return string(__def)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return string(__def)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return string(__def)
}

#define GMech_INI_Section_Exists
__section=string_lower(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_remote.ini")
            __res=ini_section_exists(__section)
            ini_close()
            return __res;
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return false;
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return false;
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return false;
}

#define GMech_INI_Update
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            //Fetch INI
            http_post_string(string(global.__gmech_api_url)+"api_get_ini.php","token="+string(global.__gmech_api_token))
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return false;
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return false;
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return false;
}

#define GMech_INI_Uploading
return global.__gmech_ini_uploading;

#define GMech_INI_Write_Real
__section=string_lower(argument0)
__variable=string_lower(argument1)
__value=real(argument2)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_remote.ini")
            ini_write_real(__section,__variable,__value)
            ini_close()
            ini_open("gmech_temp.ini")
            ini_write_real(__section,__variable,__value)
            ini_close()
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_INI_Write_String
__section=string_lower(argument0)
__variable=string_lower(argument1)
__value=string(argument2)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t4=1
        {
            if string_length(__value)<2049
            {
                if string(__section)!="" and string(__variable)!=""
                {
                    //Write change to gmech_remote.ini and gmech_temp.ini
                    ini_open("gmech_remote.ini")
                    ini_write_string(__section,__variable,__value)
                    ini_close()
                    ini_open("gmech_temp.ini")
                    ini_write_string(__section,__variable,__value)
                    ini_close()
                }
                else
                {
                    global.__gmech_error_system=5 //too Section/Variable blank
                    global.__gmech_error_spec=2
                }
            }
            else
            {
                global.__gmech_error_system=5 //too many chars
                global.__gmech_error_spec=1
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Init
//Argument0: Token
//Argument1: GMech Object ID

/*
    Step 1: Check token in database
    Step 2: Check for updates
    Step 3: Get data rights
    Step 4: Fetch individual data
    Step 5: Update gameplay statistic
    Step 6: Request completion
*/

global.__gmech_api_token=string(argument0)
//    global.__gmech_api_url="http://localhost/gmech/API/"
//    global.__gmech_avatar_url="http://localhost/gmech/avatars/"

    global.__gmech_api_url="http://www.gmechanism.com/API/"
    global.__gmech_avatar_url="http://www.gmechanism.com/avatars/"
global.__gmech_default_avatar=sprite_add(string(global.__gmech_avatar_url)+"defaultAvatar.png",1,false,true,0,0)
if is_real(argument1) then global.__gmech_object_id=argument1 else global.__gmech_object_id=(-1)
for (i=0;i<=100; i+=1) {global.__gmech_highscore_count[i]=0; global.__gmech_time_highscore_count[i]=0}
for (k=0;k<=1000;k+=1) {for (i=0;i<=30; i+=1) {global.__gmech_chat_line[k,i]=""; global.__gmech_chat_timestamp[k,i]="";}} //1 is most recent, 30 last
global.__gmech_system_status=0 //This stores statuses, like user login, signup, etc.
global.__gmech_api_ready=0
global.__gmech_play_count=0
global.__gmech_api_version="3.5.1"
global.__gmech_api_registered=0
global.__gmech_server_datetime=date_create_datetime(2000,1,1,0,0,0)
global.__gmech_error_debugging=0
global.__gmech_error_last_system=0
global.__gmech_error_last_spec=0
global.__gmech_ini_uploading=0
global.__gmech_profile_ini_uploading=0
global.__gmech_api_t1=0
global.__gmech_api_t2=0
global.__gmech_api_t3=0
global.__gmech_api_t4=0
global.__gmech_api_t5=0
global.__gmech_api_t6=0
global.__gmech_api_t7=0
global.__gmech_api_rights="0000000"
global.__gmech_api_update_required=0
global.__gmech_error_system=0
global.__gmech_error_spec=0
global.__gmech_highscore_user=ds_map_create()
global.__gmech_highscore_score=ds_map_create()
global.__gmech_highscore_timestamp=ds_map_create()
global.__gmech_time_highscore_user=ds_map_create()
global.__gmech_time_highscore_score=ds_map_create()
global.__gmech_time_highscore_timestamp=ds_map_create()
global.__gmech_achievement_game=ds_map_create()
global.__gmech_achievement_user=ds_map_create()
global.__gmech_avatar_array=ds_map_create()
global.__gmech_noavatar_array=ds_list_create()
global.__gmech_user_playing_array=ds_list_create()
global.__gmech_custom_stats_array=ds_map_create()
global.__gmech_username=""
global.__gmech_IP=""
if os_is_network_connected() or string_pos("localhost",global.__gmech_api_url)>0
{
    if global.__gmech_object_id<>(-1)
    {
        if object_exists(global.__gmech_object_id)
        {
            with(global.__gmech_object_id) instance_destroy()
            instance_create(0,0,global.__gmech_object_id)
            //Step 1
            show_debug_message("FETCH REG")
            http_post_string(global.__gmech_api_url+"api_check_registered.php","token="+string(global.__gmech_api_token))
            return 1;
        }
        else
        {
            show_debug_message("GMechAPI: ERROR: "+string(GMech_Error_Desc(1,2)))
            global.__gmech_error_system=1
            global.__gmech_error_spec=2;
            return 0;
        }
    }
    else
    {
        show_debug_message("GMechAPI: ERROR: "+string(GMech_Error_Desc(1,2)))
        global.__gmech_error_system=1
        global.__gmech_error_spec=2;
        return 0;
    }
}
else
{
    show_debug_message("GMechAPI: ERROR: Internet not connected! Going offline.")
    global.__gmech_error_system=1
    global.__gmech_error_spec=3
    return 2;
}

#define GMech_Object_Alarm_0
//Increase the server datetime
//Submit game INI changes 1 SECOND INTERVAL
if __chatUpdate>0
{
    GMech_Chat_Update(__chatUpdate)
    __chatUpdate=0
}

if __game_ini_line==0 and __game_ini_finished=0
{
    global.__gmech_server_datetime=real(date_inc_second(GMech_Server_Datetime(),1))
}
if file_exists("gmech_temp.ini") and global.__gmech_api_t4==1
{
    global.__gmech_ini_uploading=1
    //We have written to the INI, sync to the server, then delete
    //Upload that INI file.
    if string(__section)<>""
    {
        __opString="["+string(__section)+"]^^"
    }
    else
    {
        __opString=""
    }
    __section=""
    __f=file_text_open_read("gmech_temp.ini")
    if __game_ini_line>0
    {
        for(i=0;i<__game_ini_line;i+=1)
        {
            __trash=file_text_readln(__f)
        }
    }
    //Read next 20 lines and send them
    for (i=0;i<=20;i+=1)
    {
        if !file_text_eof(__f)
        {
            __game_ini_line+=1;
            __str=file_text_read_string(__f)
            file_text_readln(__f)
            //Get this section!
            if string_count("[",__str)>0 and string_count("]",__str)>0
            {
                //Tjos os a sectopm
                __section=string_replace(__str,"[","")
                __section=string_replace(__section,"]","")
            }
            __opString=string(__opString)+string(__str)+"^^"
        }
        else
        {
            __game_ini_finished=1;
        }
    }
    http_post_string(string(global.__gmech_api_url)+"api_upload_ini.php","token="+string(global.__gmech_api_token)+"&str="+string(__opString))
    show_debug_message("Sent: "+string(__opString))
    opString="["+string(__section)+"]^^"
    file_text_close(__f)
    //send final opString
    if __game_ini_finished
    {
        show_debug_message("GMechAPI: Game INI upload finished")
        //http_get(string(global.__gmech_api_url)+"api_upload_ini.php?token="+string(global.__gmech_api_token)+"&str="+string(__opString))
        file_delete("gmech_temp.ini")
        __section=""
        __game_ini_line=0;
        __game_ini_finished=0;
        global.__gmech_ini_uploading=0
        http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
    }
}
alarm[0]=room_speed

#define GMech_Object_Alarm_1
//Fetch the new stats. 30 SECOND INTERVAL
http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
if file_exists("gmech_remote.ini") then http_post_string(string(global.__gmech_api_url)+"api_get_ini.php","token="+string(global.__gmech_api_token))
if GMech_Account_LoggedIn() then http_post_string(string(global.__gmech_api_url)+"api_get_profile.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username()))
alarm[1]=room_speed*30

#define GMech_Object_Alarm_2
if file_exists("profile_temp.ini") and global.__gmech_api_t2==1 and GMech_Account_LoggedIn()
{
    global.__gmech_profile_ini_uploading=1
    //We have written to the INI, sync to the server, then delete
    //Upload that INI file.
    __profile_opString="["+string(global.__gmech_api_token)+"]^^"
    __profile_section=string(global.__gmech_api_token)
    __f=file_text_open_read("profile_temp.ini")
    if __profile_ini_line>0
    {
        for(i=0;i<=__profile_ini_line;i+=1)
        {
            __trash=file_text_readln(__f)
        }
    }
    //Read next 20 lines and send them
    for (i=0;i<=20;i+=1)
    {
        if !file_text_eof(__f)
        {
            __profile_ini_line+=1;
            __str=file_text_read_string(__f)
            file_text_readln(__f)
            //Get this section!
            if string_count("[",__str)>0 and string_count("]",__str)>0
            {
                //Tjos os a sectopm
                __profile_section=string_replace(__str,"[","")
                __profile_section=string_replace(__section,"]","")
            }
            __profile_opString=string(__profile_opString)+string(__str)+"^^"
        }
        else
        {
            __profile_ini_finished=1;
        }
    }
    http_post_string(string(global.__gmech_api_url)+"api_upload_profile.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username())+"&str="+string(__profile_opString)+"&checksum="+string(global.__gmech_checksum))
    //show_debug_message("Sent: "+string(__profile_opString))
    __profile_opString="["+string(global.__gmech_api_token)+"]^^"
    file_text_close(__f)
    //send final opString
    if __profile_ini_finished
    {
        show_debug_message("GMechAPI: Profile INI upload finished")
        //http_get(string(global.__gmech_api_url)+"api_upload_ini.php?token="+string(global.__gmech_api_token)+"&str="+string(__opString))
        file_delete("profile_temp.ini")
        __profile_section=""
        __profile_ini_line=0;
        __profile_ini_finished=0;
        global.__gmech_profile_ini_uploading=0
        http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
    }
}
alarm[2]=room_speed

#define GMech_Object_Async
if string_count("api_check_registered.php",ds_map_find_value(async_load, "url"))>0 //Step 1 of Init()
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="0"
    {
        global.__gmech_api_registered=0
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,0))
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
    else if string(__res)="1"
    {
        global.__gmech_api_registered=1
        show_debug_message("GMechAPI: Game is registered.")
        //Fetch step 2:
        http_post_string(string(global.__gmech_api_url)+"api_check_version.php","token="+string(global.__gmech_api_token)+"&version="+string(global.__gmech_api_version))
    }
    else
    {
        /*
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
        */
    }
}
if string_count("api_check_version.php",ds_map_find_value(async_load, "url"))>0 //Step 2 of Init(), check version. NOTE: This is responsible for increasing playCount
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)=string(global.__gmech_api_version) //Same version, up to date
    {
        global.__gmech_api_update_required=0
        show_debug_message("GMechAPI: API is up to date.")
    }
    else
    {
        global.__gmech_api_update_required=1
        show_debug_message("GMechAPI: WARNING: API update available: "+string(__res))
    }
    //Fetch step 3:
    http_post_string(string(global.__gmech_api_url)+"api_check_rights.php","token="+string(global.__gmech_api_token))
}
if string_count("api_check_rights.php",ds_map_find_value(async_load, "url"))>0 //Step 3 of Init() ... Get rights
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="0"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,0))
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
    else if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        global.__gmech_api_t1=real(string_copy(__res,1,1))
        global.__gmech_api_t2=real(string_copy(__res,2,1))
        global.__gmech_api_t3=real(string_copy(__res,3,1))
        global.__gmech_api_t4=real(string_copy(__res,4,1))
        global.__gmech_api_t5=real(string_copy(__res,5,1))
        global.__gmech_api_t6=real(string_copy(__res,6,1))
        global.__gmech_api_t7=real(string_copy(__res,7,1))
        global.__gmech_api_rights=string(__res)
        show_debug_message("GMechAPI: Rights received: "+string(__res))
        //Fetch step 4: (scoreboards, achievements, online INI, chatbox data, updater (if in windows)
        if global.__gmech_api_ready=0 {http_post_string(string(global.__gmech_api_url)+"api_get_scoreboard_amount.php","token="+string(global.__gmech_api_token))}
    }
}
if string(global.__gmech_api_rights)!=string(global.__gmech_api_t1)+string(global.__gmech_api_t2)+string(global.__gmech_api_t3)+string(global.__gmech_api_t4)+string(global.__gmech_api_t5)+string(global.__gmech_api_t6)+string(global.__gmech_api_t7)
{
    show_debug_message("GMechAPI: Cheating detected. Exitting.")
    game_end()
}
if string_count("api_get_scoreboard_amount.php",ds_map_find_value(async_load, "url"))>0 //Step 4 of Init()... Getting list of available scoreboards
{
    __res = ds_map_find_value(async_load, "result");
    __scAmount=0;
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        if string(__res)="0" or string(__res)=""
        {
            show_debug_message("GMechAPI: This game has no scoreboards. Submit a highscore to create a board.")
            if global.__gmech_api_ready=0 {http_post_string(string(global.__gmech_api_url)+"api_get_achievements.php","token="+string(global.__gmech_api_token))}
        }
        else
        {
            //Clear our DS_Maps
            ds_map_clear(global.__gmech_highscore_user)
            ds_map_clear(global.__gmech_highscore_score)
            ds_map_clear(global.__gmech_highscore_timestamp)
            //We have a LIST of these boards. Parse the list. id_id_id...
            __total=string_count("_",__res)
            if real(__total)>5 and global.__gmech_api_t1=0 {show_debug_message("GMechAPI: WARNING: You have more than 5 scoreboards. Only the first 5 can be used. To get rid of this limitation, go to www.gmechanism.com.") __total=5}
            for (i=1;i<=__total;i+=1)
            {
                __tid=real(string_copy(__res,1,1))
                __res=string_replace(__res,string(__tid)+"_","")
                //Fetch this table
                http_post_string(string(global.__gmech_api_url)+"api_get_scoreboard.php?table="+string(__tid)+"&randomInt="+string(round(random(99999))),"token="+string(global.__gmech_api_token)+"&table="+string(__tid))
                __scAmount+=1;
            }
        }
    }
}
if string_count("api_get_scoreboard.php",ds_map_find_value(async_load, "url"))>0 //Step 4 of Init() continued... Specific scoreboard to decode
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else if string(__res)="0"
    {
        show_debug_message("GMechAPI: WARNING: HS Table exists but contains no data. Delete it from the Dev Portal.")
        __scAmount-=1;
    }
    else if string(__res)<>""
    {
        __scAmount-=1;
        //We have a scoreboard. Figure out which one
        __url=ds_map_find_value(async_load,"url")
        show_debug_message(__url)
        __tableID=string_copy(__url,string_pos("?table=",__url),15)
        __tableID=string_replace(__tableID,"?table=","")
        __tableID=string_copy(__tableID,1,string_pos("&",__tableID))
        __tableID=string_replace(__tableID,"&","")
        show_debug_message("GMechAPI: Retrieved scoreboard "+string(__tableID)+", parsing...")
        //Parse the rest of the scoreboard: user_score_timestamp|
        __total=string_count("|",__res)
        global.__gmech_highscore_count[real(__tableID)]=0
        for (i=1;i<=__total;i+=1)
        {
            __data=string_copy(__res,1,string_pos("|",__res))
            __data=string_replace_all(__data,"|","")
            __res=string_replace(__res,string(__data)+"|","")
            //We now have __data: user_score_timestamp
            __dUser=string_copy(__data,1,string_pos("_",__data))
            __dUser=string_replace_all(__dUser,"_","")
            __data=string_replace_all(__data,string(__dUser)+"_","")
            __dScore=string_copy(__data,1,string_pos("_",__data))
            __dScore=string_replace_all(__dScore,"_","")
            __data=string_replace_all(__data,string(__dScore)+"_","")
            __dTimestamp=string_replace_all(__data,"|","")
            //We have our parsed data. Map it. 'table|slot'
            ds_map_add(global.__gmech_highscore_user,string(__tableID)+"|"+string(i),string(__dUser))
            ds_map_add(global.__gmech_highscore_score,string(__tableID)+"|"+string(i),real(__dScore))
            ds_map_add(global.__gmech_highscore_timestamp,string(__tableID)+"|"+string(i),string(__dTimestamp))
            global.__gmech_highscore_count[real(__tableID)]+=1
        }
    }
    else
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    if __scAmount==0 and global.__gmech_api_ready=0
    {
        //Clear the achievement DS_Map
        ds_map_clear(global.__gmech_achievement_game)
        ds_map_clear(global.__gmech_achievement_user)
        //Fetch step 4 continued, achv
        if global.__gmech_api_ready=0 {http_post_string(string(global.__gmech_api_url)+"api_get_achievements.php","token="+string(global.__gmech_api_token))}
    }
}
if string_count("api_get_achievements.php",ds_map_find_value(async_load, "url"))>0 //Step 4 of Init() continued... List of achievements defined, includes user achievements as well
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else if string(__res)<>"0"
    {
        show_debug_message("GMechAPI: Parsing achievements for Game.")
        //achID_title|achID_title|$achID|achID
        __gmAch=string_copy(__res,1,string_pos("$",__res))
        __gmAch=string_replace_all(__gmAch,"$","")
        __gmTotal=string_count("|",__gmAch)
        for(i=1;i<=__gmTotal;i+=1)
        {
            __data=string_copy(__gmAch,1,string_pos("|",__gmAch))
            __data=string_replace_all(__data,"|","")
            __gmAch=string_replace(__gmAch,string(__data)+"|","")
            //Now parse data: achID_title
            __gmAchID=string_copy(__data,1,string_pos("_",__data))
            __gmAchID=string_replace_all(__gmAchID,"_","")
            __gmAchTitle=string_replace(__data,__gmAchID+"_","")
            //Now we have the game ID and Title
            show_debug_message("GMechAPI: GameAchID "+string(__gmAchID)+" - "+string(__gmAchTitle))
            ds_map_add(global.__gmech_achievement_game,"ach"+string(__gmAchID),string(__gmAchTitle)) //Added to our achievement map
        }
        //User achievements comenext
        __userAch=string_replace(__res,string_copy(__res,1,string_pos("$",__res)),"")
        __userAch=string_replace_all(__userAch,"$","")
        if string(__userAch)<>""
        {
            //Parse this user's achievements
            show_debug_message("GMechAPI: Parsing achievements for User")
            __userTotal=string_count("|",__userAch)
            for(i=0;i<__userTotal;i+=1)
            {
                __thisAch=string_copy(__userAch,0,string_pos("|",__userAch))
                __thisAch=string_replace_all(__thisAch,"|","")
                __userAch=string_replace(__userAch,__thisAch+"|","") //_all(__userAch,"|","")
                if string(__thisAch)<>""
                {
                    show_debug_message("GMechAPI: UserAchID "+string(__thisAch))
                    ds_map_add(global.__gmech_achievement_user,"ach"+string(__thisAch),"got")
                }
            }
        }
        else
        {
            show_debug_message("GMechAPI: This user has no achievements defined.")
        }
        if GMech_Account_LoggedIn()
        {
            //Get their INI 
            http_post_string(string(global.__gmech_api_url)+"api_get_profile.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username())+"&checksum="+string(global.__gmech_checksum))
        }
    }
    else
    {
        show_debug_message("GMechAPI: This game has no achievements defined.")
    }
    //Step 4 continued: Fetch Game INI
    //Clear game INI first
    if global.__gmech_api_ready=0
    {
        //Step 5 init: get statistics
        http_post_string(string(global.__gmech_api_url)+"api_get_ini.php","token="+string(global.__gmech_api_token))
    }
}
if string_count("api_get_ini.php",ds_map_find_value(async_load, "url"))>0 //Step 4 of Init() continued... Getting INI data
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else if string(__res)<>"0"
    {
        if file_exists("gmech_remote.ini") then file_delete("gmech_remote.ini")
        //We have an INI
        __gini=file_text_open_write("gmech_remote.ini")
        file_text_write_string(__gini,string(__res))
        file_text_writeln(__gini)
        file_text_close(__gini)
        show_debug_message("GMechAPI: INI Parsed.")
    }
    else
    {
        show_debug_message("GMechAPI: This game has no INI data.")
    }
    if global.__gmech_api_ready=0
    {
        //Step 5 init: get statistics
        http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
    }
}

if string_count("api_get_stats.php",ds_map_find_value(async_load, "url"))>0 //Step 5: statistics
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        //Parse the result
        ds_list_clear(global.__gmech_user_playing_array)
        ds_map_clear(global.__gmech_custom_stats_array)
        __total=string_count("|",__res)
        __result=string(__res)
        for(i=1;i<=__total;i+=1)
        {
            __thisElement=string_copy(__result,1,string_pos("|",__result))
            __thisElement=string_replace(__thisElement,"|","")
            __result=string_replace(__result,__thisElement+"|","")
            //Element consists of key:value
            __key=string_copy(__thisElement,1,string_pos(":",__thisElement))
            __key=string_replace(__key,":","")
            __thisElement=string_replace(__thisElement,__key+":","")
            __value=string(__thisElement)
            if string(__key)="playCount"
            {
                global.__gmech_play_count=real(__value)
            }
            else if string(__key)="dateTime"
            {
                global.__gmech_server_datetime=real(GMech_Backend_PHPtoGML_Datetime(__value))
            }
            else if string(__key)="userPlaying"
            {
                ds_list_add(global.__gmech_user_playing_array,string(__value))
            }
            else if string_count("custom",__key)>0
            {
                //Custom statistic... String OR integer!
                //if is_real(__value)
                //{
                    ds_map_add(global.__gmech_custom_stats_array,string(__key),real(__value))
                //}
                //else
                //{
                    //ds_map_add(global.__gmech_custom_stats_array,string(__key),string(__value))
                //}
            }
        }
        //API startup is now ready
        if global.__gmech_api_ready=0
        {
            show_debug_message("GMechAPI: Fully initialized!")
            global.__gmech_api_ready=1
            GMech_Chat_Update(1)
        }
    }
}
if string_count("api_account_login.php",ds_map_find_value(async_load, "url"))>0 //Logging in the user
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1" //Server error
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        if string(__res)="0"
        {
            global.__gmech_system_status=4
            global.__gmech_error_system=3
            global.__gmech_error_spec=4
        }
        else
        {
            if string(__res)="-2"
            {
                show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,0))
                global.__gmech_system_status=5
                global.__gmech_error_system=1
                global.__gmech_error_spec=0
            }
            else
            {
                if string(__res)="2"
                {
                    show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(3,1))
                    global.__gmech_error_system=3
                    global.__gmech_error_spec=1
                    global.__gmech_system_status=2
                }
                else
                {
                    global.__gmech_system_status=1
                    __user=string_copy(__res,1,string_pos("|||",__res))
                    __user=string_replace_all(__user,"|","")
                    __check=string_replace_all(__res,__user+"|||","")
                    global.__gmech_username=string_lower(__user)
                    global.__gmech_checksum=__check
                    ds_map_clear(global.__gmech_achievement_game)
                    ds_map_clear(global.__gmech_achievement_user)
                    //Fetch step 4 continued, achv
                    http_post_string(string(global.__gmech_api_url)+"api_get_achievements.php","token="+string(global.__gmech_api_token)+"&user="+string(global.__gmech_username))
                    http_post_string(string(global.__gmech_api_url)+"api_get_profile.php","token="+string(global.__gmech_api_token)+"&user="+string(GMech_Account_Username())+"&checksum="+string(global.__gmech_checksum))
                }
            }
        }
    }
}
if string_count("api_account_signup.php",ds_map_find_value(async_load, "url"))>0 //Signing up the user
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1" //Server error
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        if string(__res)="0"
        {
            global.__gmech_system_status=4
            global.__gmech_error_system=3
            global.__gmech_error_spec=4
        }
        else
        {
            if string(__res)="-2" //Token not registered
            {
                show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,0))
                global.__gmech_error_system=1
                global.__gmech_error_spec=0
            }
            else
            {
                if string(__res)="2" //USername is taken!
                {
                    global.__gmech_error_system=3
                    global.__gmech_error_spec=6
                    global.__gmech_system_status=6
                }
                else if string(__res)="1"
                {
                    global.__gmech_system_status=7
                }
            }
        }
    }
}
if string_count("api_submit_highscore.php",ds_map_find_value(async_load, "url"))>0 //Highscore results
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1" //Server error
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else
    {
        if string(__res)="1"
        {
            show_debug_message("GMechAPI: Highscore submitted successfully.")
        }
        else
        {
            //Other error
            show_debug_message("GMechAPI: ERROR: "+string(__res))
        }
    }
    http_post_string(string(global.__gmech_api_url)+"api_get_scoreboard_amount.php","token="+string(global.__gmech_api_token))
}
if string_count("api_get_time_scoreboard.php",ds_map_find_value(async_load, "url"))>0 //Request for a time-limited scoreboard
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else if string(__res)="0"
    {
        show_debug_message("GMechAPI: Time-limited HS data unavailable for specified datetime limit.")
    }
    else if string(__res)<>""
    {
        //We have a scoreboard. Figure out which one
        __url=ds_map_find_value(async_load,"url")
        __tableID=string_copy(__url,string_pos("?table=",__url),string_pos("&from=",__url)-string_pos("?table=",__url))
        __tableID=string_replace(__tableID,"?table=","")
        __tableID=string_copy(__tableID,1,string_pos("&",__tableID))
        __tableID=string_replace(__tableID,"&","")
        show_debug_message("GMechAPI: Retrieved time-limited scoreboard "+string(__tableID)+", parsing...")
        //Parse the rest of the scoreboard: user_score_timestamp|
        __total=string_count("|",__res)
        for (i=1;i<=__total;i+=1)
        {
            __data=string_copy(__res,1,string_pos("|",__res))
            __data=string_replace_all(__data,"|","")
            __res=string_replace(__res,string(__data)+"|","")
            //We now have __data: user_score_timestamp
            __dUser=string_copy(__data,1,string_pos("_",__data))
            __dUser=string_replace_all(__dUser,"_","")
            __data=string_replace_all(__data,string(__dUser)+"_","")
            __dScore=string_copy(__data,1,string_pos("_",__data))
            __dScore=string_replace_all(__dScore,"_","")
            __data=string_replace_all(__data,string(__dScore)+"_","")
            __dTimestamp=string_replace_all(__data,"|","")
            //We have our parsed data. Map it. 'table|slot'
            ds_map_add(global.__gmech_time_highscore_user,string(__tableID)+"|"+string(i),string(__dUser))
            ds_map_add(global.__gmech_time_highscore_score,string(__tableID)+"|"+string(i),real(__dScore))
            ds_map_add(global.__gmech_time_highscore_timestamp,string(__tableID)+"|"+string(i),string(__dTimestamp))
            global.__gmech_time_highscore_count[real(__tableID)]+=1
        }
    }
    else
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
}
if string_count("api_check_avatar.php",ds_map_find_value(async_load, "url"))>0 //Does the requested user have an avatar?
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)<>"0"
    {
        __ret=string(ds_map_find_value(global.__gmech_avatar_array,string(__res)))
        if string(__ret)="0"
        {
            ds_map_add(global.__gmech_avatar_array,string_lower(__res),sprite_add(string(global.__gmech_avatar_url)+string(__res)+".png",1,false,true,0,0))
        }
    }
    else
    {
        __url=ds_map_find_value(async_load,"url")
        __tableID=string_copy(__url,string_pos("?user=",__url),15)
        __tableID=string_replace(__tableID,"?user=","")
        ds_list_add(global.__gmech_noavatar_array,__tableID)
    }
}
if string_count("api_chat_get.php",ds_map_find_value(async_load, "url"))>0 //Getting a chatbox update from the server
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)<>"0"
    {
        //We have an update!
        //user%%%timestamp%%%text%%%room|||, first is newest
        //Every time we parse a new message, move the arrays down the line (29 -> 30, 28 -> 29, ... ) and set 1 to recent
        //GMech_Chat_Reset(1)
        //msgCount=string_count("|||",__res)
        for (__i=1;__i<=30;__i+=1)
        {
            __thisChunk=string_copy(__res,1,string_pos("|||",__res)-1)
            __thisChunk=string_replace(__thisChunk,"|||","")
            __res=string_replace(__res,__thisChunk+"|||","")
            //We have our chunk
            __user=string_copy(__thisChunk,1,string_pos("%%%",__thisChunk)-1)
            __user=string_replace(__user,"%%%","")
            __thisChunk=string_replace(__thisChunk,__user+"%%%","")
            __timestamp=string_copy(__thisChunk,1,string_pos("%%%",__thisChunk)-1)
            __timestamp=string_replace(__timestamp,"%%%","")
            __thisChunk=string_replace(__thisChunk,__timestamp+"%%%","")
            __text=string_copy(__thisChunk,1,string_pos("%%%",__thisChunk)-1)
            __text=string_replace(__text,"%%%","")
            __thisChunk=string_replace(__thisChunk,__text+"%%%","")
            __room=real(__thisChunk)
            //We have our bits, now move the arrays!
            //for (l=30;l>1; l-=1) {global.__gmech_chat_line[__room,l]=global.__gmech_chat_line[__room,l-1]; global.__gmech_chat_timestamp[__room,l]=global.__gmech_chat_timestamp[__room,l-1];}
            //set 1
            //show_debug_message("Procesed: "+string(__i)+string(__user+": "+__text))
            global.__gmech_chat_timestamp[__room,__i]=string(__timestamp)
            global.__gmech_chat_line[__room,__i]=string(__user+": "+__text)
        }
    }
}
if string_count("api_get_profile.php",ds_map_find_value(async_load, "url"))>0 //Getting the user's profile INI
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)="-1"
    {
        show_debug_message("GMechAPI: ERROR: "+GMech_Error_Desc(1,-1))
        global.__gmech_error_system=1
        global.__gmech_error_spec=(-1)
    }
    else if string(__res)<>"0"
    {
        if file_exists("gmech_user.ini") then file_delete("gmech_user.ini")
        //We have an INI
        __gini=file_text_open_write("gmech_user.ini")
        file_text_write_string(__gini,string(__res))
        file_text_writeln(__gini)
        file_text_close(__gini)
        show_debug_message("GMechAPI: Profile INI Parsed.")
    }
    else
    {
        //No INI data
    }
    http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
}
if string_count("api_upload_ini.php",ds_map_find_value(async_load, "url"))>0 //Reply from the server on INI.
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)<>"0"
    {
        show_debug_message("Game INI Reply: "+string(__res))
    }
    global.__gmech_object_id.alarm[0]=1
}
if string_count("api_upload_profile.php",ds_map_find_value(async_load, "url"))>0 //Reply from the server on profile INI.
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)<>"0"
    {
        show_debug_message("Profile INI Reply: "+string(__res))
    }
    global.__gmech_object_id.alarm[2]=1
}
if string_count("api_submit_stat.php",ds_map_find_value(async_load, "url"))>0 //Reply from the server on the statistics submission
{
    __res = ds_map_find_value(async_load, "result");
    if string(__res)<>""
    {
        show_debug_message("Statistic Reply: "+string(__res))
    }
}

#define GMech_Object_Create
object_set_persistent(self,true)
alarm[0]=room_speed
alarm[1]=room_speed*30
alarm[2]=room_speed
__game_ini_line=0
__game_ini_finished=0
__profile_ini_line=0
__profile_ini_finished=0

__section=""
__profile_section=""
__opString=""
__profile_opString=""

__chatUpdate=0

#define GMech_Object_Game_End
if (global.__gmech_error_debugging)
{
    //Log it
    __f=file_text_open_append("GMech_Log.txt")
    file_text_write_string(__f,string(date_datetime_string(date_current_datetime()))+" ----- SESSION END -----")
    file_text_writeln(__f)
    file_text_close(__f)
}
//Send logout
http_post_string(string(global.__gmech_api_url)+"api_account_logout.php","token="+string(global.__gmech_api_token)+"&user="+string(global.__gmech_username))
global.__gmech_username=""
if file_exists("gmech_remote.ini") then file_delete("gmech_remote.ini")
if file_exists("gmech_user.ini") then file_delete("gmech_user.ini")

#define GMech_Object_Step
if (global.__gmech_error_debugging)
{
    //Every time the debugger changes codes, log it
    if global.__gmech_error_last_system<>GMech_Error_System() or global.__gmech_error_last_spec<>GMech_Error_Spec()
    {
        if GMech_Error_System()>0
        {
            //Log it
            __f=file_text_open_append("GMech_Log.txt")
            file_text_write_string(__f,string(date_datetime_string(date_current_datetime()))+" ERROR: System  "+string(GMech_Error_System())+", Specific "+string(GMech_Error_Spec())+" | Description: "+string(GMech_Error_Desc(GMech_Error_System(),GMech_Error_Spec())))
            file_text_writeln(__f)
            file_text_close(__f)
            //Set it
            global.__gmech_error_last_system=GMech_Error_System()
            global.__gmech_error_last_spec=GMech_Error_Spec()
        }
        else
        {
            //Cearing the error
            //Log it
            __f=file_text_open_append("GMech_Log.txt")
            file_text_write_string(__f,string(date_datetime_string(date_current_datetime()))+" Error handler cleared!")
            file_text_writeln(__f)
            file_text_close(__f)
            //Set it
            global.__gmech_error_last_system=GMech_Error_System()
            global.__gmech_error_last_spec=GMech_Error_Spec()
        }
    }
}

#define GMech_Profile_Get_Birthday_Day
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_real("profile","day",0)
            ini_close()
            return real(__res)
        }
        else
        {
            return (-1)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return (-1)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return (-1)
}

#define GMech_Profile_Get_Birthday_Month
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("profile","month","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ININotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_Birthday_Year
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_real("profile","year",0)
            ini_close()
            return real(__res)
        }
        else
        {
            return (-1)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return (-1)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return (-1)
}

#define GMech_Profile_Get_Email
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("profile","email","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ProfileNotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_Firstname
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("profile","firstname","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return string("ProfileNotLoaded")
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_JoinDate
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("system","join","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ProfileNotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_LastLogin
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("system","last","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ProfileNotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_Lastname
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("profile","lastname","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ProfileNotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Get_Website
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if file_exists("gmech_user.ini")
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_read_string("profile","website","N/A")
            ini_close()
            return string(__res)
        }
        else
        {
            return "ProfileNotLoaded"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Key_Exists
__section=string(global.__gmech_api_token)
__key=string_lower(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t2=1
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            __res=ini_key_exists(__section,__key)
            ini_close()
            return __res;
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return false;
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return false;
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return false;
}

#define GMech_Profile_Read_Real
__section=string(global.__gmech_api_token)
__variable=string_lower(argument0)
__def=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t2=1
        {
            if file_exists("gmech_user.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_user.ini")
                __res=ini_read_real(__section,__variable,__def)
                ini_close()
                return real(__res)
            }
            else
            {
                return real(__def)
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return real(__def)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return real(__def)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return real(__def)
}

#define GMech_Profile_Read_String
__section=string(global.__gmech_api_token)
__variable=string_lower(argument0)
__def=string(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t2=1
        {
            if file_exists("gmech_user.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_user.ini")
                __res=ini_read_string(__section,__variable,__def)
                ini_close()
                return string(__res)
            }
            else
            {
                return string(__def)
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
            return string(__def)
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return string(__def)
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return string(__def)
}

#define GMech_Profile_Set_Birthday_Day
__day=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                if __day>0 and __day<32
                {
                    //Write change to gmech_remote.ini and gmech_temp.ini
                    ini_open("gmech_user.ini")
                    __res=ini_write_real("profile","day",__day)
                    ini_close()
                    ini_open("profile_temp.ini")
                    __res=ini_write_real("profile","day",__day)
                    ini_close()
                    return 1;
                }
                else
                {
                    return "InvalidData"
                }
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Set_Birthday_Month
__month=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                if __month>0 and __month<13
                {
                    if __month=1 then __month_str="January"
                    if __month=2 then __month_str="February"
                    if __month=3 then __month_str="March"
                    if __month=4 then __month_str="April"
                    if __month=5 then __month_str="May"
                    if __month=6 then __month_str="June"
                    if __month=7 then __month_str="July"
                    if __month=8 then __month_str="August"
                    if __month=9 then __month_str="September"
                    if __month=10 then __month_str="October"
                    if __month=11 then __month_str="November"
                    if __month=12 then __month_str="December"
                    //Write change to gmech_remote.ini and gmech_temp.ini
                    ini_open("gmech_user.ini")
                    __res=ini_write_string("profile","month",__month_str)
                    ini_close()
                    ini_open("profile_temp.ini")
                    __res=ini_write_string("profile","month",__month_str)
                    ini_close()
                    return 1;
                }
                else
                {
                    return "InvalidData"
                }
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Set_Birthday_Year
__year=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                if __year>1900 and __year<2050
                {
                    //Write change to gmech_remote.ini and gmech_temp.ini
                    ini_open("gmech_user.ini")
                    __res=ini_write_real("profile","year",__year)
                    ini_close()
                    ini_open("profile_temp.ini")
                    __res=ini_write_real("profile","year",__year)
                    ini_close()
                    return 1;
                }
                else
                {
                    return "InvalidData"
                }
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Set_Firstname
__firstname=string(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_user.ini")
                __res=ini_write_string("profile","firstname",__firstname)
                ini_close()
                ini_open("profile_temp.ini")
                __res=ini_write_string("profile","firstname",__firstname)
                ini_close()
                return 1;
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Set_Lastname
__lastname=string(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_user.ini")
                __res=ini_write_string("profile","lastname",__lastname)
                ini_close()
                ini_open("profile_temp.ini")
                __res=ini_write_string("profile","lastname",__lastname)
                ini_close()
                return 1;
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Set_Website
__website=string(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if GMech_Account_LoggedIn()
        {
            if file_exists("gmech_user.ini")
            {
                //Write change to gmech_remote.ini and gmech_temp.ini
                ini_open("gmech_user.ini")
                __res=ini_write_string("profile","website",__website)
                ini_close()
                ini_open("profile_temp.ini")
                __res=ini_write_string("profile","website",__website)
                ini_close()
                return 1;
            }
            else
            {
                return string("ProfileNotLoaded")
            }
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "GMechNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "GMechNotReady"
}

#define GMech_Profile_Uploading
return global.__gmech_profile_ini_uploading;

#define GMech_Profile_Write_Real
__section=string(global.__gmech_api_token)
__variable=string_lower(argument0)
__value=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t2=1
        {
            //Write change to gmech_remote.ini and gmech_temp.ini
            ini_open("gmech_user.ini")
            ini_write_real(__section,__variable,__value)
            ini_close()
            ini_open("profile_temp.ini")
            ini_write_real(__section,__variable,__value)
            ini_close()
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Profile_Write_String
__section=string(global.__gmech_api_token)
__variable=string_lower(argument0)
__value=string(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if global.__gmech_api_t2=1
        {
            if string_length(__value)<2049
            {
                if string(__section)!="" and string(__variable)!=""
                {
                    if GMech_Account_LoggedIn()
                    {
                        //Write change to gmech_remote.ini and gmech_temp.ini
                        ini_open("gmech_user.ini")
                        ini_write_string(__section,__variable,__value)
                        ini_close()
                        ini_open("profile_temp.ini")
                        ini_write_string(__section,__variable,__value)
                        ini_close()
                    }
                    else
                    {
                        global.__gmech_error_system=5 //User not logged in
                        global.__gmech_error_spec=3
                    }
                }
                else
                {
                    global.__gmech_error_system=5 //too Section/Variable blank
                    global.__gmech_error_spec=2
                }
            }
            else
            {
                global.__gmech_error_system=5 //too many chars
                global.__gmech_error_spec=1
            }
        }
        else
        {
            global.__gmech_error_system=5 //Not authorized
            global.__gmech_error_spec=0
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_Server_Datetime
return real(global.__gmech_server_datetime)

#define GMech_Stats_Decrease
__statID=real(argument0)
__dec=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __statID<6 or global.__gmech_api_t1=1
        {
            //Read the stats
            if ds_map_exists(global.__gmech_custom_stats_array,"custom"+string(__statID))
            {
                __oldValue=ds_map_find_value(global.__gmech_custom_stats_array,"custom"+string(__statID))
                __newValue=real(__oldValue)-real(__dec)
                ds_map_replace(global.__gmech_custom_stats_array,"custom"+string(__statID),__newValue)
                http_post_string(string(global.__gmech_api_url)+"api_submit_stat.php","token="+string(global.__gmech_api_token)+"&stat="+string(__statID)+"&val="+string(__newValue))
            }
        }
    }
}

#define GMech_Stats_Get
__statID=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        //Read the stats
        if global.__gmech_custom_stats_array>(-1) and ds_map_exists(global.__gmech_custom_stats_array,"custom"+string(__statID))
        {
            return real(ds_map_find_value(global.__gmech_custom_stats_array,"custom"+string(__statID)));
        }
        else
        {
            return (-1);
        }
    }
}

#define GMech_Stats_Increase
__statID=real(argument0)
__inc=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __statID<6 or global.__gmech_api_t1=1
        {
            //Read the stats
            if ds_map_exists(global.__gmech_custom_stats_array,"custom"+string(__statID))
            {
                __oldValue=ds_map_find_value(global.__gmech_custom_stats_array,"custom"+string(__statID))
                __newValue=real(__oldValue)+real(__inc)
                ds_map_replace(global.__gmech_custom_stats_array,"custom"+string(__statID),__newValue)
                http_post_string(string(global.__gmech_api_url)+"api_submit_stat.php","token="+string(global.__gmech_api_token)+"&stat="+string(__statID)+"&val="+string(__newValue))
            }
        }
    }
}

#define GMech_Stats_Plays
return global.__gmech_play_count;

#define GMech_Stats_Set
__statID=real(argument0)
__val=real(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __statID<6 or global.__gmech_api_t1=1
        {
            //Read the stats
            ds_map_replace(global.__gmech_custom_stats_array,"custom"+string(__statID),real(__val))
            http_post_string(string(global.__gmech_api_url)+"api_submit_stat.php","token="+string(global.__gmech_api_token)+"&stat="+string(__statID)+"&val="+string(__val))
        }
    }
}

#define GMech_Stats_Update
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        //Read the stats
        http_post_string(string(global.__gmech_api_url)+"api_get_stats.php","token="+string(global.__gmech_api_token))
    }
}

#define GMech_Stats_User_Playing
__slot=real(argument0)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        //Read the stats
        return string(ds_list_find_value(global.__gmech_user_playing_array,__slot-1))
    }
}

#define GMech_Stats_User_Playing_Count
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        //Read the stats
        return ds_list_size(global.__gmech_user_playing_array)
    }
}

#define GMech_Status
if global.__gmech_api_ready=0
{
    return -1;
}
else
{
    return global.__gmech_system_status;
}

#define GMech_Status_Clear
global.__gmech_system_status=0

#define GMech_THS_Clear
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        //Convert the GML datetime to PHP datetime
        global.__gmech_time_highscore_count[argument0]=0
        ds_map_clear(global.__gmech_time_highscore_user)
        ds_map_clear(global.__gmech_time_highscore_score)
        ds_map_clear(global.__gmech_time_highscore_timestamp) //Clearing the time-limited HS maps first prevents conflict
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_THS_Count
if is_real(global.__gmech_time_highscore_count[argument0])
{
    return global.__gmech_time_highscore_count[argument0]
}
else
{
    return (-1)
}

#define GMech_THS_Rank
__tableID=argument0
__user=string_lower(argument1)
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                __endRank=0;
                for(__i=0;__i<=GMech_THS_Count(__tableID);__i+=1)
                {
                    //Search for the user
                    if string_lower(ds_map_find_value(global.__gmech_time_highscore_user,string(__tableID)+"|"+string(__i)))=string(__user)
                    {
                        //We found him! Cancel the loop
                        __endRank=__i
                        break;
                    }
                }
                return __endRank;
            }
            else
            {
                global.__gmech_error_system=2
                global.__gmech_error_spec=4
                return "InvalidSlotID"
            }
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
            return "InvalidTableID"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "TokenNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "APINotReady"
}

#define GMech_THS_Request
__tableID=argument0
__GMLDatetimeFrom=argument1
__GMLDatetimeTo=argument2
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            //Convert the GML datetime to PHP datetime
            ds_map_clear(global.__gmech_time_highscore_user)
            ds_map_clear(global.__gmech_time_highscore_score)
            ds_map_clear(global.__gmech_time_highscore_timestamp) //Clearing the time-limited HS maps first prevents conflict
            http_post_string(string(global.__gmech_api_url)+"api_get_time_scoreboard.php?table="+string(__tableID)+"&from="+string(GMech_Backend_GMLtoPHP_Datetime(__GMLDatetimeFrom)),"token="+string(global.__gmech_api_token)+"&table="+string(__tableID)+"&from="+string(GMech_Backend_GMLtoPHP_Datetime(__GMLDatetimeFrom))+"&to="+string(GMech_Backend_GMLtoPHP_Datetime(__GMLDatetimeTo)))
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_THS_Score
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
             {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_time_highscore_score,string(__tableID)+"|"+string(__slotID)))
                return real(__ret)
            }
            else
            {
                 global.__gmech_error_system=2
                 global.__gmech_error_spec=4
            } 
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
}

#define GMech_THS_Timestamp
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_time_highscore_timestamp,string(__tableID)+"|"+string(__slotID)))
                if string(__ret)<>"0"
                {
                    return string(__ret)
                }
                else
                {
                    return "N/A"
                }
            }
            else
            {
                return "InvalidSlotID"
            }
        }
        else
        {
            return "InvalidTableID"
        }
    }
    else
    {
        return "TokenNotRegistered"
    }
}
else
{
    return "APINotReady";
}

#define GMech_THS_User
__tableID=argument0
__slotID=argument1
if global.__gmech_api_ready=1
{
    if global.__gmech_api_registered=1
    {
        if __tableID>0 and ((__tableID>5 and global.__gmech_api_t1=1) or (__tableID<=5))
        {
            if __slotID>0
            {
                //Our table is within legal bounds
                //Extract the username from the map
                __ret=string(ds_map_find_value(global.__gmech_time_highscore_user,string(__tableID)+"|"+string(__slotID)))
                if string(__ret)<>"0"
                {
                     return string(__ret)
                }
                else
                {
                     return "N/A"
                }
            }
            else
            {
                global.__gmech_error_system=2
                global.__gmech_error_spec=4
                return "InvalidSlotID"
            }
        }
        else
        {
            global.__gmech_error_system=2
            global.__gmech_error_spec=1
            return "InvalidTableID"
        }
    }
    else
    {
        global.__gmech_error_system=1
        global.__gmech_error_spec=0
        return "TokenNotRegistered"
    }
}
else
{
    global.__gmech_error_system=1
    global.__gmech_error_spec=4
    return "APINotReady"
}

#define GMech_Updates
return global.__gmech_api_update_required;

