# cub3D_tester

This tester launch every maps in maps_test folder.

If the map name start with a 'b_' it's mean it's a bad map so the tester will expect a error and a exit code.
If the map name start with a 'g_' it's mean it's a good map so the tester will expect no error and the launch of the program then it will be timeout by the script.
if the map name start with a 'v_' it's mean it's a valid map so the tester will expect a error and the launch of the program then it will be timeout by the script.

If you dont need the last case, just remove the maps how start with a 'v_'.

You can add as many test you want but you have to follow the 3 rules above in order to the script work as expected.