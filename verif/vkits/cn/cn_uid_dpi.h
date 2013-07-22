//-*- mode: C++;-*-
// ***********************************************************************
// * CAVIUM NETWORKS CONFIDENTIAL                                        *
// *                                                                     *
// *                         PROPRIETARY NOTE                            *
// *                                                                     *
// *  This software contains information confidential and proprietary    *
// *  to Cavium Networks.  It shall not be reproduced in whole or in     *
// *  part, or transferred to other documents, or disclosed to third     *
// *  parties, or used for any purpose other than that for which it was  *
// *  obtained, without the prior written consent of Cavium Networks.    *
// *  (c) 2011, Cavium Networks.  All rights reserved.                   *
// *                                                                     *
// ***********************************************************************
// * File        : cn_uid_dpi.h
// * Author      : Jack Perveiler
// * Description : dpi functions for uid_c to be accessed by C
// ***********************************************************************


#ifndef __CN_UID_DPI_H__
#define __CN_UID_DPI_H__

using namespace std;

#include <string>

int cn_uid_get_id(string _prefix);

#endif
