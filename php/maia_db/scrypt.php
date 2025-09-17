<?php

/**
 * This file contains an example helper classes for the php-scrypt extension.
 *
 * As with all cryptographic code; it is recommended that you use a tried and
 * tested library which uses this library; rather than rolling your own.
 *
 * PHP version 5
 *
 * @category Security
 * @package  Scrypt
 * @author   Dominic Black <thephenix@gmail.com>
 * @license  http://www.opensource.org/licenses/BSD-2-Clause BSD 2-Clause License
 * @link     http://github.com/DomBlack/php-scrypt
 */

/**
 * This class abstracts away from scrypt module, allowing for easy use.
 *
 * You can create a new hash for a password by calling Password::hash($password)
 *
 * You can check a password by calling Password::check($password, $hash)
 *
 * @category Security
 * @package  Scrypt
 * @author   Dominic Black <thephenix@gmail.com>
 * @license  http://www.opensource.org/licenses/BSD-2-Clause BSD 2-Clause License
 * @link     http://github.com/DomBlack/php-scrypt
 */
abstract class Password
{

    /**
     *
     * @var int The key length
     */
private static $_keyLength = 32;

    /**
     * Get the byte-length of the given string
     *
     * @param string $str Input string
     *
     * @return int
     */
protected static function strlen( $str )
{
    static $isShadowed = null;

    if ($isShadowed === null) {
        $isShadowed = extension_loaded('mbstring') &&
            ini_get('mbstring.func_overload') & 2;
    }

    if ($isShadowed) {
        return mb_strlen($str, '8bit');
    } else {
        return strlen($str);
    }
}

    /**
     * Generates a random salt
     *
