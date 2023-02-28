/*
 * Copyright © 2005 Aurelien Jarno
 * Copyright © 2006 Robert Millan
 * Copyright © 2008, 2009 Guillem Jover
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef LIBBSD_STDLIB_H
#define LIBBSD_STDLIB_H

#include <sys/cdefs.h>
#include <sys/stat.h>
#include <stdint.h>
#include <stdlib.h>

/* For compatibility with NetBSD, which defines humanize_number here. */
#include <libutil.h>

/* FIXME: Temporary inclusions to avoid API breakage, will be removed soon. */
#include <bsd/stdio.h>
#include <bsd/unistd.h>

__BEGIN_DECLS
u_int32_t arc4random();
void arc4random_stir();
void arc4random_addrandom(u_char *dat, int datlen);

int dehumanize_number(const char *str, int64_t *size);

char *getprogname ();
void setprogname (char *);

int heapsort (void *, size_t, size_t, int (*)(const void *, const void *));

long long strtonum(const char *nptr, long long minval, long long maxval,
                   const char **errstr);
__END_DECLS

#endif
