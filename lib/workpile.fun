#!/bin/bash
########################################
# Project :	Workpile
#
# Description :	
# Functions relative to workpile as whole.
#
# Author :	Lertsenem	<lertsenem@yahoo.fr>
########################################

[ -z "$WP_TAG_WORKPILE_FUN" ] || return
WP_TAG_WORKPILE_FUN=1

# IMPORTS
########################################

. "$_WORKPILE_ROOT/lib/workpile.cst"

# FUNCTIONS
########################################

#
# Description : 
#
# Arguments :   $1/
#
# Returns :     
# ======================================
wp_exit()
{
	# Arguments
	local arg_rv="$1"
	local arg_message="$2"

	[ -n "$arg_rv" ] || arg_rv=0

	# Print message if it exists
	[ -n "$arg_message" ] && echo "$arg_message"

	# Exit with RV arg_rv
	exit "$arg_rv"
} # wp_exit()

#
# Description : 
#
# Arguments :   $1/
#
# Returns :     
# ======================================
wp_task()
{
	# Arguments
	local arg_task="$1"

	# Local Variables
	local lv_task=""
	
	[-n "$arg_task" ] || return "$WP_RV_EMPTYTASK"

	lv_task="${arg_task/$WP_TAG_FIRSTTASK/}"
	lv_task="${lv_task/$WP_TAG_LASTTASK/}"

	echo "$lv_task"

	return "$WP_RV_OK"

} # wp_task()

#
# Description : 
#
# Arguments :   $1/
#
# Returns :     
# ======================================
wp_hash()
{
	# Arguments
	local arg_str="$1"
	
	echo "$( echo "$arg_str" | sha1sum | cut -d ' ' -f 1 )"

	return "$WP_RV_OK"
}


#
# Description :	
#
# Arguments :	-
#
# Returns :	
# ======================================
wp_get_firsttask()
{
	# Local Variables
	local lv_firsttask="$( basename "$( readlink "$WP_LOC_SAVTASKS/$WP_TAG_FIRSTTASK" 2> "/dev/null" )" )"
	
	[ -z "$lv_firsttask" ] && return "$WP_RV_NOSUCHTASK"

	echo "$lv_firsttask"
	
	return "$WP_RV_OK"
} # wp_get_firsttask()


#
# Description :	
#
# Arguments :	-
#
# Returns :	
# ======================================
wp_get_lasttask()
{
	# Local Variables
	local lv_lasttask="$( basename "$( readlink "$WP_LOC_SAVTASKS/$WP_TAG_LASTTASK" 2> "/dev/null" )" )"
	
	[ -z "$lv_lasttask" ] && return "$WP_RV_NOSUCHTASK"

	echo "$lv_lasttask"

	return "$WP_RV_OK"
	
} # wp_get_lasttask()


#
# Description :	
#
# Arguments :	$1/arg_task
#
# Returns :	
# ======================================
wp_get_taskname()
{
	# Arguments
	local arg_task="$1"

	# Local variables
	local lv_taskinfos=""
	
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	lv_taskinfos="$(ls "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS" 2> "/dev/null")"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKNAME}p" "$lv_taskinfos")"

	return "$WP_RV_OK"
} # wp_get_taskname()


#
# Description :	
#
# Arguments :	$1/arg_task
#
# Returns :	
# ======================================
wp_get_tasknext()
{
	# Arguments
	local arg_task="$1"

	# Local variables
	local lv_taskinfos=""
	
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	lv_taskinfos="$(ls "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS" 2> "/dev/null")"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKNEXT}p" "$lv_taskinfos")"

	return "$WP_RV_OK"
} # wp_get_tasknext()


#
# Description :	
#
# Arguments :	$1/arg_task
#
# Returns :	
# ======================================
wp_get_taskprev()
{
	# Arguments
	local arg_task="$1"

	# Local variables
	local lv_taskinfos=""
	
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	lv_taskinfos="$(ls "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS" 2> "/dev/null")"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKPREV}p" "$lv_taskinfos")"

	return "$WP_RV_OK"
} # wp_get_taskprev()


#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_add_task()
{
	# Arguments
	local arg_taskname="$1"
	local arg_tasknext="$2"
	local arg_taskprev="$3"

	# Local Variables
	local lv_task=""
	local lv_date="$( $WP_CMD_DATE )"

	# Checks Arguments
	[ -z "$arg_taskname" ] && return "$WP_RV_EMPTYTASK"

	# Hash task
	lv_task="$( wp_hash "$lv_date$arg_taskname" )"
	
	# Create task
	mkdir -p "$WP_LOC_SAVTASKS/$lv_task"

	#TODO repérer les collisions SHA1

	# Create taskinfos file
	echo -e -n "\n\n\n\n\n\n" > "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

	# Insert infos in taskinfos file
	sed -i "${WP_NUM_TASKNAME}c\\${arg_taskname}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -i "${WP_NUM_TASKNEXT}c\\${arg_tasknext}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -i "${WP_NUM_TASKPREV}c\\${arg_taskprev}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -i "${WP_NUM_TASKCREA}c\\${lv_date}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

	# Echo task id
	echo "$lv_task"

	# Ok
	return "$WP_RV_OK"
} # wp_add_task()


#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_addinfo_taskfg()
{
	# Arguments
	local arg_task="$1"
	
	# Local Variables
	local lv_date="$( $WP_CMD_DATE )"
	
	# Checks Arguments
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	# Add info
	echo "${WP_TAG_TASKFG}$($WP_CMD_DATE)" >> "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS"

	# Ok
	return "$WP_RV_OK"
} # wp_addinfo_taskfg()


#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_addinfo_taskbg()
{
	# Arguments
	local arg_task="$1"
	
	# Local Variables
	local lv_date="$( $WP_CMD_DATE )"
	
	# Checks Arguments
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	# Add info
	echo "${WP_TAG_TASKBG}$($WP_CMD_DATE)" >> "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS"

	# Ok
	return "$WP_RV_OK"
} # wp_addinfo_taskbg()


#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_set_firsttask()
{
	# Arguments
	local arg_task="$1"

	# Local Variables
	lv_oldfirsttask=""

	# Checks Arguments
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	# Get old firt task
	lv_oldfirsttask="$( wp_get_firsttask )"

	[ "$arg_task" == "$lv_oldfirsttask" ] && return "$WP_RVNOTHINGTODO"

	# Change old first task 'prev' field
	[ -n "$lv_oldfirsttask" ] && sed -i "${WP_NUM_TASKPREV}c\\${arg_task}" "$WP_LOC_SAVTASKS/$lv_oldfirsttask/$WP_TAG_TASKINFOS"

	# Change new first task 'prev' field (to void)
	sed -i ${WP_NUM_TASKPREV}c\\\\ "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS"

	# Move firstness
	rm "$WP_LOC_SAVTASKS/$WP_TAG_FIRSTTASK" 2> "/dev/null"
	ln -s "$arg_task" "$WP_LOC_SAVTASKS/$WP_TAG_FIRSTTASK"

	# Actualize infos
	wp_addinfo_taskbg "$lv_oldfirsttask"
	wp_addinfo_taskfg "$arg_task"

	return "$WP_RV_OK"

} # wp_set_firsttask()


#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_set_lasttask()
{
	# Arguments
	local arg_task="$1"

	# Local Variables
	lv_oldlasttask=""

	# Checks Arguments
	[ -z "$arg_task" ] && return "$WP_RV_EMPTYTASK"

	# Get old last task
	lv_oldlasttask="$( wp_get_lasttask )"

	[ "$arg_task" == "$lv_oldlasttask" ] && return "$WP_RVNOTHINGTODO"

	# Change old last tag 'next' field
	[ -n "$lv_oldlasttask" ] && sed -i "${WP_NUM_TASKNEXT}c\\${arg_task}" "$WP_LOC_SAVTASKS/$lv_oldlasttask/$WP_TAG_TASKINFOS"

	# Change new last task 'next' field (to void)
	sed -i ${WP_NUM_TASKNEXT}c\\\\ "$WP_LOC_SAVTASKS/$arg_task/$WP_TAG_TASKINFOS"

	# Move lastness
	rm "$WP_LOC_SAVTASKS/$WP_TAG_LASTTASK" 2> "/dev/null"
	ln -s "$arg_task" "$WP_LOC_SAVTASKS/$WP_TAG_LASTTASK"

	return "$WP_RV_OK"

} # wp_set_lasttask()

#
# Description :	
#
# Arguments :	$1/
#
# Returns :	
# ======================================
wp_clean_list()
{
	rm "$WP_LOC_SAVTASKS/$WP_TAG_FIRSTTASK" 2> "/dev/null"
	rm "$WP_LOC_SAVTASKS/$WP_TAG_LASTTASK" 2> "/dev/null"

	return "$WP_RV_OK"

} # wp_clean_list()
