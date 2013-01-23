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
# Arguments :	-
#
# Returns :	
# ======================================
wp_get_firsttask()
{
	# Local Variables
	local lv_firsttask="$(ls -d $WP_LOC_SAVTASKS/*$WP_TAG_FIRSTTASK* 2> "/dev/null")"
	
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
	local lv_lasttask="$(ls -d $WP_LOC_SAVTASKS/*$WP_TAG_LASTTASK* 2> "/dev/null")"
	
	[ -z "$lv_lasttask" ] && return "$WP_RV_NOSUCHTASK"

	echo "$lv_lasttask"
	
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

	lv_taskinfos="$(ls $arg_task/$WP_TAG_TASKINFOS 2> "/dev/null")"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKNAME}p" "$taskinfos")"

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

	lv_taskinfos="$(ls $arg_task/$WP_TAG_TASKINFOS)"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKNEXT}p" "$taskinfos")"

	return "$WP_RV_OK"
} # wp_get_taskname()


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

	lv_taskinfos="$(ls $arg_task/$WP_TAG_TASKINFOS)"

	[ -z "$lv_taskinfos" ] && return "$WP_RV_NOTASKINFOS"

	echo "$(sed -n "${WP_NUM_TASKPREV}p" "$taskinfos")"

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
	lv_task="$( echo "$lv_date$arg_taskname" | $WP_CMD_HASH )"
	
	# Create task
	mkdir -p "$WP_LOC_SAVTASKS/$lv_task"

	#TODO repérer les collisions SHA1

	# Create taskinfos file
	echo -en "\n\n\n\n" > "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

	# Insert infos in taskinfos file
	sed -in "${WP_NUM_TASKNAME}c\\${arg_taskname}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -in "${WP_NUM_TASKNEXT}c\\${arg_tasknext}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -in "${WP_NUM_TASKPREV}c\\${arg_taskprev}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"
	sed -in "${WP_NUM_TASKCREA}c\\${arg_date}" "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

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
	echo "${WP_TAG_TASKFG}${arg_date}" >> "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

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
	echo "${WP_TAG_TASKBG}${arg_date}" >> "$WP_LOC_SAVTASKS/$lv_task/$WP_TAG_TASKINFOS"

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

	# Move firstness
	[ -n "$lv_oldfirsttask" ] && mv "$WP_LOC_SAVTASKS/$lv_oldfirsttask" "$WP_LOC_SAVTASKS/${lv_oldfirsttask/$WP_TAG_FIRSTTASK/}"
	mv "$WP_LOC_SAVTASKS/$arg_task" "$WP_LOC_SAVTASKS/${WP_TAG_FIRSTTASK}${arg_task}"

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

	# Move lastness
	mv "$WP_LOC_SAVTASKS/$lv_oldlasttask" "$WP_LOC_SAVTASKS/${lv_oldlasttask/$WP_TAG_LASTTASK/}"
	mv "$WP_LOC_SAVTASKS/$arg_task" "$WP_LOC_SAVTASKS/${WP_TAG_LASTTASK}${arg_task}"

} # wp_set_lasttask()
