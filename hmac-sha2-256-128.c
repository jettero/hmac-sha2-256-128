
// ../linux-4.8.build/net/xfrm/xfrm_algo.c

#include <linux/pfkeyv2.h>
#include <linux/crypto.h>
#include <net/xfrm.h>
#include <net/esp.h>

static struct xfrm_algo_desc my_list[] = {{
    .name = "hmac(sha256)-128",
    .compat = "sha256-128",

    .uinfo = {
        .auth = {
            .icv_truncbits = 128,
            .icv_fullbits = 256,
        }
    },

    .pfkey_supported = 1,

    .desc = {
        .sadb_alg_id      = SADB_X_AALG_SHA2_256HMAC,
        .sadb_alg_ivlen   = 0,
        .sadb_alg_minbits = 256,
        .sadb_alg_maxbits = 256
    }
}}
