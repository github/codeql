// This file contains auto-generated code.

namespace Microsoft
{
    namespace AspNetCore
    {
        namespace Identity
        {
            // Generated from `Microsoft.AspNetCore.Identity.IdentityRole` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityRole : Microsoft.AspNetCore.Identity.IdentityRole<string>
            {
                public IdentityRole(string roleName) => throw null;
                public IdentityRole() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityRole<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityRole<TKey> where TKey : System.IEquatable<TKey>
            {
                public virtual string ConcurrencyStamp { get => throw null; set => throw null; }
                public virtual TKey Id { get => throw null; set => throw null; }
                public IdentityRole(string roleName) => throw null;
                public IdentityRole() => throw null;
                public virtual string Name { get => throw null; set => throw null; }
                public virtual string NormalizedName { get => throw null; set => throw null; }
                public override string ToString() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityRoleClaim<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityRoleClaim<TKey> where TKey : System.IEquatable<TKey>
            {
                public virtual string ClaimType { get => throw null; set => throw null; }
                public virtual string ClaimValue { get => throw null; set => throw null; }
                public virtual int Id { get => throw null; set => throw null; }
                public IdentityRoleClaim() => throw null;
                public virtual void InitializeFromClaim(System.Security.Claims.Claim other) => throw null;
                public virtual TKey RoleId { get => throw null; set => throw null; }
                public virtual System.Security.Claims.Claim ToClaim() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUser` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUser : Microsoft.AspNetCore.Identity.IdentityUser<string>
            {
                public IdentityUser(string userName) => throw null;
                public IdentityUser() => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUser<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUser<TKey> where TKey : System.IEquatable<TKey>
            {
                public virtual int AccessFailedCount { get => throw null; set => throw null; }
                public virtual string ConcurrencyStamp { get => throw null; set => throw null; }
                public virtual string Email { get => throw null; set => throw null; }
                public virtual bool EmailConfirmed { get => throw null; set => throw null; }
                public virtual TKey Id { get => throw null; set => throw null; }
                public IdentityUser(string userName) => throw null;
                public IdentityUser() => throw null;
                public virtual bool LockoutEnabled { get => throw null; set => throw null; }
                public virtual System.DateTimeOffset? LockoutEnd { get => throw null; set => throw null; }
                public virtual string NormalizedEmail { get => throw null; set => throw null; }
                public virtual string NormalizedUserName { get => throw null; set => throw null; }
                public virtual string PasswordHash { get => throw null; set => throw null; }
                public virtual string PhoneNumber { get => throw null; set => throw null; }
                public virtual bool PhoneNumberConfirmed { get => throw null; set => throw null; }
                public virtual string SecurityStamp { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public virtual bool TwoFactorEnabled { get => throw null; set => throw null; }
                public virtual string UserName { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUserClaim<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUserClaim<TKey> where TKey : System.IEquatable<TKey>
            {
                public virtual string ClaimType { get => throw null; set => throw null; }
                public virtual string ClaimValue { get => throw null; set => throw null; }
                public virtual int Id { get => throw null; set => throw null; }
                public IdentityUserClaim() => throw null;
                public virtual void InitializeFromClaim(System.Security.Claims.Claim claim) => throw null;
                public virtual System.Security.Claims.Claim ToClaim() => throw null;
                public virtual TKey UserId { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUserLogin<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUserLogin<TKey> where TKey : System.IEquatable<TKey>
            {
                public IdentityUserLogin() => throw null;
                public virtual string LoginProvider { get => throw null; set => throw null; }
                public virtual string ProviderDisplayName { get => throw null; set => throw null; }
                public virtual string ProviderKey { get => throw null; set => throw null; }
                public virtual TKey UserId { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUserRole<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUserRole<TKey> where TKey : System.IEquatable<TKey>
            {
                public IdentityUserRole() => throw null;
                public virtual TKey RoleId { get => throw null; set => throw null; }
                public virtual TKey UserId { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.IdentityUserToken<>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public class IdentityUserToken<TKey> where TKey : System.IEquatable<TKey>
            {
                public IdentityUserToken() => throw null;
                public virtual string LoginProvider { get => throw null; set => throw null; }
                public virtual string Name { get => throw null; set => throw null; }
                public virtual TKey UserId { get => throw null; set => throw null; }
                public virtual string Value { get => throw null; set => throw null; }
            }

            // Generated from `Microsoft.AspNetCore.Identity.RoleStoreBase<,,,>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class RoleStoreBase<TRole, TKey, TUserRole, TRoleClaim> : System.IDisposable, Microsoft.AspNetCore.Identity.IRoleStore<TRole>, Microsoft.AspNetCore.Identity.IRoleClaimStore<TRole>, Microsoft.AspNetCore.Identity.IQueryableRoleStore<TRole> where TKey : System.IEquatable<TKey> where TRole : Microsoft.AspNetCore.Identity.IdentityRole<TKey> where TRoleClaim : Microsoft.AspNetCore.Identity.IdentityRoleClaim<TKey>, new() where TUserRole : Microsoft.AspNetCore.Identity.IdentityUserRole<TKey>, new()
            {
                public abstract System.Threading.Tasks.Task AddClaimAsync(TRole role, System.Security.Claims.Claim claim, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual TKey ConvertIdFromString(string id) => throw null;
                public virtual string ConvertIdToString(TKey id) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> CreateAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected virtual TRoleClaim CreateRoleClaim(TRole role, System.Security.Claims.Claim claim) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> DeleteAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public void Dispose() => throw null;
                public Microsoft.AspNetCore.Identity.IdentityErrorDescriber ErrorDescriber { get => throw null; set => throw null; }
                public abstract System.Threading.Tasks.Task<TRole> FindByIdAsync(string id, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task<TRole> FindByNameAsync(string normalizedName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<System.Security.Claims.Claim>> GetClaimsAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<string> GetNormalizedRoleNameAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetRoleIdAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetRoleNameAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract System.Threading.Tasks.Task RemoveClaimAsync(TRole role, System.Security.Claims.Claim claim, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public RoleStoreBase(Microsoft.AspNetCore.Identity.IdentityErrorDescriber describer) => throw null;
                public abstract System.Linq.IQueryable<TRole> Roles { get; }
                public virtual System.Threading.Tasks.Task SetNormalizedRoleNameAsync(TRole role, string normalizedName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetRoleNameAsync(TRole role, string roleName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected void ThrowIfDisposed() => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> UpdateAsync(TRole role, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
            }

            // Generated from `Microsoft.AspNetCore.Identity.UserStoreBase<,,,,,,,>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class UserStoreBase<TUser, TRole, TKey, TUserClaim, TUserRole, TUserLogin, TUserToken, TRoleClaim> : Microsoft.AspNetCore.Identity.UserStoreBase<TUser, TKey, TUserClaim, TUserLogin, TUserToken>, System.IDisposable, Microsoft.AspNetCore.Identity.IUserStore<TUser>, Microsoft.AspNetCore.Identity.IUserRoleStore<TUser> where TKey : System.IEquatable<TKey> where TRole : Microsoft.AspNetCore.Identity.IdentityRole<TKey> where TRoleClaim : Microsoft.AspNetCore.Identity.IdentityRoleClaim<TKey>, new() where TUser : Microsoft.AspNetCore.Identity.IdentityUser<TKey> where TUserClaim : Microsoft.AspNetCore.Identity.IdentityUserClaim<TKey>, new() where TUserLogin : Microsoft.AspNetCore.Identity.IdentityUserLogin<TKey>, new() where TUserRole : Microsoft.AspNetCore.Identity.IdentityUserRole<TKey>, new() where TUserToken : Microsoft.AspNetCore.Identity.IdentityUserToken<TKey>, new()
            {
                public abstract System.Threading.Tasks.Task AddToRoleAsync(TUser user, string normalizedRoleName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected virtual TUserRole CreateUserRole(TUser user, TRole role) => throw null;
                protected abstract System.Threading.Tasks.Task<TRole> FindRoleAsync(string normalizedRoleName, System.Threading.CancellationToken cancellationToken);
                protected abstract System.Threading.Tasks.Task<TUserRole> FindUserRoleAsync(TKey userId, TKey roleId, System.Threading.CancellationToken cancellationToken);
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<string>> GetRolesAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<TUser>> GetUsersInRoleAsync(string normalizedRoleName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task<bool> IsInRoleAsync(TUser user, string normalizedRoleName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task RemoveFromRoleAsync(TUser user, string normalizedRoleName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public UserStoreBase(Microsoft.AspNetCore.Identity.IdentityErrorDescriber describer) : base(default(Microsoft.AspNetCore.Identity.IdentityErrorDescriber)) => throw null;
            }

            // Generated from `Microsoft.AspNetCore.Identity.UserStoreBase<,,,,>` in `Microsoft.Extensions.Identity.Stores, Version=5.0.0.0, Culture=neutral, PublicKeyToken=adb9793829ddae60`
            public abstract class UserStoreBase<TUser, TKey, TUserClaim, TUserLogin, TUserToken> : System.IDisposable, Microsoft.AspNetCore.Identity.IUserTwoFactorStore<TUser>, Microsoft.AspNetCore.Identity.IUserTwoFactorRecoveryCodeStore<TUser>, Microsoft.AspNetCore.Identity.IUserStore<TUser>, Microsoft.AspNetCore.Identity.IUserSecurityStampStore<TUser>, Microsoft.AspNetCore.Identity.IUserPhoneNumberStore<TUser>, Microsoft.AspNetCore.Identity.IUserPasswordStore<TUser>, Microsoft.AspNetCore.Identity.IUserLoginStore<TUser>, Microsoft.AspNetCore.Identity.IUserLockoutStore<TUser>, Microsoft.AspNetCore.Identity.IUserEmailStore<TUser>, Microsoft.AspNetCore.Identity.IUserClaimStore<TUser>, Microsoft.AspNetCore.Identity.IUserAuthenticatorKeyStore<TUser>, Microsoft.AspNetCore.Identity.IUserAuthenticationTokenStore<TUser>, Microsoft.AspNetCore.Identity.IQueryableUserStore<TUser> where TKey : System.IEquatable<TKey> where TUser : Microsoft.AspNetCore.Identity.IdentityUser<TKey> where TUserClaim : Microsoft.AspNetCore.Identity.IdentityUserClaim<TKey>, new() where TUserLogin : Microsoft.AspNetCore.Identity.IdentityUserLogin<TKey>, new() where TUserToken : Microsoft.AspNetCore.Identity.IdentityUserToken<TKey>, new()
            {
                public abstract System.Threading.Tasks.Task AddClaimsAsync(TUser user, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task AddLoginAsync(TUser user, Microsoft.AspNetCore.Identity.UserLoginInfo login, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected abstract System.Threading.Tasks.Task AddUserTokenAsync(TUserToken token);
                public virtual TKey ConvertIdFromString(string id) => throw null;
                public virtual string ConvertIdToString(TKey id) => throw null;
                public virtual System.Threading.Tasks.Task<int> CountCodesAsync(TUser user, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> CreateAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected virtual TUserClaim CreateUserClaim(TUser user, System.Security.Claims.Claim claim) => throw null;
                protected virtual TUserLogin CreateUserLogin(TUser user, Microsoft.AspNetCore.Identity.UserLoginInfo login) => throw null;
                protected virtual TUserToken CreateUserToken(TUser user, string loginProvider, string name, string value) => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> DeleteAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public void Dispose() => throw null;
                public Microsoft.AspNetCore.Identity.IdentityErrorDescriber ErrorDescriber { get => throw null; set => throw null; }
                public abstract System.Threading.Tasks.Task<TUser> FindByEmailAsync(string normalizedEmail, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task<TUser> FindByIdAsync(string userId, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<TUser> FindByLoginAsync(string loginProvider, string providerKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract System.Threading.Tasks.Task<TUser> FindByNameAsync(string normalizedUserName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                protected abstract System.Threading.Tasks.Task<TUserToken> FindTokenAsync(TUser user, string loginProvider, string name, System.Threading.CancellationToken cancellationToken);
                protected abstract System.Threading.Tasks.Task<TUser> FindUserAsync(TKey userId, System.Threading.CancellationToken cancellationToken);
                protected abstract System.Threading.Tasks.Task<TUserLogin> FindUserLoginAsync(string loginProvider, string providerKey, System.Threading.CancellationToken cancellationToken);
                protected abstract System.Threading.Tasks.Task<TUserLogin> FindUserLoginAsync(TKey userId, string loginProvider, string providerKey, System.Threading.CancellationToken cancellationToken);
                public virtual System.Threading.Tasks.Task<int> GetAccessFailedCountAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetAuthenticatorKeyAsync(TUser user, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<System.Security.Claims.Claim>> GetClaimsAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<string> GetEmailAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<bool> GetEmailConfirmedAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<bool> GetLockoutEnabledAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<System.DateTimeOffset?> GetLockoutEndDateAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<Microsoft.AspNetCore.Identity.UserLoginInfo>> GetLoginsAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<string> GetNormalizedEmailAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetNormalizedUserNameAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetPasswordHashAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetPhoneNumberAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<bool> GetPhoneNumberConfirmedAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetSecurityStampAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetTokenAsync(TUser user, string loginProvider, string name, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task<bool> GetTwoFactorEnabledAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetUserIdAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<string> GetUserNameAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public abstract System.Threading.Tasks.Task<System.Collections.Generic.IList<TUser>> GetUsersForClaimAsync(System.Security.Claims.Claim claim, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task<bool> HasPasswordAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<int> IncrementAccessFailedCountAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task<bool> RedeemCodeAsync(TUser user, string code, System.Threading.CancellationToken cancellationToken) => throw null;
                public abstract System.Threading.Tasks.Task RemoveClaimsAsync(TUser user, System.Collections.Generic.IEnumerable<System.Security.Claims.Claim> claims, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public abstract System.Threading.Tasks.Task RemoveLoginAsync(TUser user, string loginProvider, string providerKey, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task RemoveTokenAsync(TUser user, string loginProvider, string name, System.Threading.CancellationToken cancellationToken) => throw null;
                protected abstract System.Threading.Tasks.Task RemoveUserTokenAsync(TUserToken token);
                public abstract System.Threading.Tasks.Task ReplaceClaimAsync(TUser user, System.Security.Claims.Claim claim, System.Security.Claims.Claim newClaim, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public virtual System.Threading.Tasks.Task ReplaceCodesAsync(TUser user, System.Collections.Generic.IEnumerable<string> recoveryCodes, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task ResetAccessFailedCountAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetAuthenticatorKeyAsync(TUser user, string key, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task SetEmailAsync(TUser user, string email, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetEmailConfirmedAsync(TUser user, bool confirmed, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetLockoutEnabledAsync(TUser user, bool enabled, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetLockoutEndDateAsync(TUser user, System.DateTimeOffset? lockoutEnd, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetNormalizedEmailAsync(TUser user, string normalizedEmail, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetNormalizedUserNameAsync(TUser user, string normalizedName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetPasswordHashAsync(TUser user, string passwordHash, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetPhoneNumberAsync(TUser user, string phoneNumber, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetPhoneNumberConfirmedAsync(TUser user, bool confirmed, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetSecurityStampAsync(TUser user, string stamp, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetTokenAsync(TUser user, string loginProvider, string name, string value, System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Threading.Tasks.Task SetTwoFactorEnabledAsync(TUser user, bool enabled, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                public virtual System.Threading.Tasks.Task SetUserNameAsync(TUser user, string userName, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken)) => throw null;
                protected void ThrowIfDisposed() => throw null;
                public abstract System.Threading.Tasks.Task<Microsoft.AspNetCore.Identity.IdentityResult> UpdateAsync(TUser user, System.Threading.CancellationToken cancellationToken = default(System.Threading.CancellationToken));
                public UserStoreBase(Microsoft.AspNetCore.Identity.IdentityErrorDescriber describer) => throw null;
                public abstract System.Linq.IQueryable<TUser> Users { get; }
            }

        }
    }
}
