//
//  TermsOfUseView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 2/3/24.
//
// TODO: Get table of contents navigating to relevant section

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ScrollViewReader { value in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Terms of Use")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        
                        Text("Last Updated: February 03, 2024")
                            .font(.headline)
                            .padding(.bottom, 10)
                    }
                    TermsIntroductionSection()
                    
                    // Table of Contents
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Table of Contents")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        ForEach(1...24, id: \.self) { number in
//                            Button(action: {
//                                print("Scrolling to section \(number)")
//                                value.scrollTo(number, anchor: .top)
//                            }) {
                                Text("\(number). \(sectionTitle(for: number))")
                                    .padding(.vertical, 2)
                            //}
                        }

                    }
                    .padding(.bottom, 20)
                    
                    // Sections
                    SectionHolderView()
                    SectionHolderContinuedView()
                    
                    //  Placeholder for other sections
//                    ForEach(2...24, id: \.self) { number in
//                        Text("Section Placeholder for \(sectionTitle(for: number))")
//                            .id(number)
//                            .padding(.bottom, 10)
//                    }
                }
                .padding()
            }
        }
    }
    
    func sectionTitle(for number: Int) -> String {
        switch number {
        case 1: return "Our Services"
        case 2: return "Intellectual Property Rights"
        case 3: return "User Representations"
        case 4: return "User Registration"
        case 5: return "Prohibited Activities"
        case 6: return "User Generated Contributions"
        case 7: return "Contribution License"
        case 8: return "Mobile Application License"
        case 9: return "Services Management"
        case 10: return "Privacy Policy"
        case 11: return "Copyright Infringements"
        case 12: return "Term and Termination"
        case 13: return "Modifications and Interruptions"
        case 14: return "Governing Law"
        case 15: return "Dispute Resolution"
        case 16: return "Corrections"
        case 17: return "Disclaimer"
        case 18: return "Limitations of Liability"
        case 19: return "Indenification"
        case 20: return "User Data"
        case 21: return "Electronic Communications, Transactions, and Signatures"
        case 22: return "California Users and Residents"
        case 23: return "Miscellaneous"
        case 24: return "Contact Us"
        default: return "Section"
        }
    }
}

// Section Holder
struct SectionHolderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            OurServicesSection().id(1)
            IntellectualPropertySection().id(2)
            UserRepresentationsSection().id(3)
            UserRegistrationSection().id(4)
            ProhibitedActivitiesSection().id(5)
            UserGeneratedContributionsSection().id(6)
            ContributionLicenseSection().id(7)
            MobileApplicationLicenseSection().id(8)
            ServicesManagementSection().id(9)
            PrivacyPolicySection().id(10)
        }
    }
}

// Section Holder continued
struct SectionHolderContinuedView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            CopyrightInfringementsSection().id(11)
            TermAndTerminationSection().id(12)
//            ModificationsAndInterruptionsSection().id(13)
//            GoverningLawSection().id(14)
//            DisputeResolutionSection().id(15)
//            CorrectionsSection().id(16)
//            DisclaimerSection().id(17)
//            LimitationsOfLiabilitySection().id(18)
//            IndemnificationSection().id(19)
//            UserDataSection().id(20)
//            ElectronicCommunicationsTransactionsAndSignaturesSection().id(21)
//            CaliforniaUsersAndResidentsSection().id(22)
//            MiscellaneousSection().id(23)
//            ContactUsSection().id(24)
        }
    }
}


// Introduction Section
struct TermsIntroductionSection: View {
    var body: some View {
        Group {
            SectionTitle("Agreement to Our Legal Terms")
            Text("We are Nuclear Design | Lifestyle Architecture (\"Company,\" \"we,\" \"us,\" \"our\"). We operate the mobile application Seed (the \"App\"), along with any other related products and services that refer or link to these legal terms (collectively, the \"Services\").")
                .padding(.bottom, 10)
            Text("By accessing and using the Services, you acknowledge you have read, understood, and agree to be bound by these Legal Terms. If you disagree with any part of these terms, you must discontinue using the Services immediately.")
                .padding(.bottom, 10)
            
            Text("We may update these Legal Terms at any time, with updates taking effect upon the \"Last updated\" date. It is your responsibility to review these terms periodically for changes.")
                .padding(.bottom, 10)
            
            Text("Eligibility: The Services are intended for users who are at least 18 years old.")
                .padding(.bottom, 10)
            
            Text("For your records, consider printing a copy of these terms.")
                .padding(.bottom, 10)
        }
    }
}

struct OurServicesSection: View {
    var body: some View {
        Group {
            Text("1. Our Services")
                .font(.title)
                .fontWeight(.bold)
            
            Text("The information provided when using the Services is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation or which would subject us to any registration requirement within such jurisdiction or country. Accordingly, those persons who choose to access the Services from other locations do so on their own initiative and are solely responsible for compliance with local laws, if and to the extent local laws are applicable.")
                .padding(.bottom, 10)
            Text("The Services are not tailored to comply with industry-specific regulations (Health Insurance Portability and Accountability Act (HIPAA), Federal Information Security Management Act (FISMA), etc.), so if your interactions would be subjected to such laws, you may not use the Services. You may not use the Services in a way that would violate the Gramm-Leach-Bliley Act (GLBA).")
                .padding(.bottom, 10)
        }
    }
}

struct IntellectualPropertySection: View {
    var body: some View {
        Group {
            Text("2. Intellectual Property Rights")
                .font(.title)
                .fontWeight(.bold)
            
            SectionTitle("Our Intellectual Property")
            Text("We are the owner or the licensee of all intellectual property rights in our Services, including all source code, databases, functionality, software, website designs, audio, video, text, photographs, and graphics in the Services (collectively, the \"Content\"), as well as the trademarks, service marks, and logos contained therein (the \"Marks\"). \n\nOur Content and Marks are protected by copyright and trademark laws (and various other intellectual property rights and unfair competition laws) and treaties in the United States and around the world. \n\nThe Content and Marks are provided in or through the Services \"AS IS\" for your personal, non-commercial use or internal business purpose only.")
                .padding(.bottom, 10)
            
            SectionTitle("Your Use of Our Services")
            Text("Subject to your compliance with these Legal Terms, including the \"PROHIBITED ACTIVITIES\" section below, we grant you a non-exclusive, non-transferable, revocable license to:")
            BulletPoint("access the Services; and")
            BulletPoint("download or print a copy of any portion of the Content to which you have properly gained access,")
            Text("solely for your personal, non-commercial use or internal business purpose.\n\nExcept as set out in this section or elsewhere in our Legal Terms, no part of the Services and no Content or Marks may be copied, reproduced, aggregated, republished, uploaded, posted, publicly displayed, encoded, translated, transmitted, distributed, sold, licensed, or otherwise exploited for any commercial purpose whatsoever, without our express prior written permission. \n\nIf you wish to make any use of the Services, Content, or Marks other than as set out in this section or elsewhere in our Legal Terms, please address your request to: nucleardesign1@gmail.com. If we ever grant you the permission to post, reproduce, or publicly display any part of our Services or Content, you must identify us as the owners or licensors of the Services, Content, or Marks and ensure that any copyright or proprietary notice appears or is visible on posting, reproducing, or displaying our Content.\n\nWe reserve all rights not expressly granted to you in and to the Services, Content, and Marks.\n\nAny breach of these Intellectual Property Rights will constitute a material breach of our Legal Terms and your right to use our Services will terminate immediately.")
                .padding(.bottom, 10)
            SubmissionsAndContributionsView()
        }
    }
}
    
    // Subsection of Intellectual Property
struct SubmissionsAndContributionsView: View {
    var body: some View {
        Group {
            SectionTitle("Your submissions and contributions")
            Text("""
    Please review this section and the "PROHIBITED ACTIVITIES" section carefully prior to using our Services to understand the (a) rights you give us and (b) obligations you have when you post or upload any content through the Services.
    
    **Submissions:** By directly sending us any question, comment, suggestion, idea, feedback, or other information about the Services ("Submissions"), you agree to assign to us all intellectual property rights in such Submission. You agree that we shall own this Submission and be entitled to its unrestricted use and dissemination for any lawful purpose, commercial or otherwise, without acknowledgment or compensation to you.
    
    **Contributions:** The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality during which you may create, submit, post, display, transmit, publish, distribute, or broadcast content and materials to us or through the Services, including but not limited to text, writings, video, audio, photographs, music, graphics, comments, reviews, rating suggestions, personal information, or other material ("Contributions"). Any Submission that is publicly posted shall also be treated as a Contribution.
    
    You understand that Contributions may be viewable by other users of the Services.
    
    **When you post Contributions, you grant us a license (including use of your name, trademarks, and logos):** By posting any Contributions, you grant us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to: use, copy, reproduce, distribute, sell, resell, publish, broadcast, retitle, store, publicly perform, publicly display, reformat, translate, excerpt (in whole or in part), and exploit your Contributions (including, without limitation, your image, name, and voice) for any purpose, commercial, advertising, or otherwise, to prepare derivative works of, or incorporate into other works, your Contributions, and to sublicense the licenses granted in this section. Our use and distribution may occur in any media formats and through any media channels.
    
    This license includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide.
    
    **You are responsible for what you post or upload:** By sending us Submissions and/or posting Contributions through any part of the Services or making Contributions accessible through the Services by linking your account through the Services to any of your social networking accounts, you:
    """)
            BulletPoint("confirm that you have read and agree with our \"PROHIBITED ACTIVITIES\" and will not post, send, publish, upload, or transmit through the Services any Submission nor post any Contribution that is illegal, harassing, hateful, harmful, defamatory, obscene, bullying, abusive, discriminatory, threatening to any person or group, sexually explicit, false, inaccurate, deceitful, or misleading;")
            BulletPoint("to the extent permissible by applicable law, waive any and all moral rights to any such Submission and/or Contribution;")
            BulletPoint("warrant that any such Submission and/or Contributions are original to you or that you have the necessary rights and licenses to submit such Submissions and/or Contributions and that you have full authority to grant us the above-mentioned rights in relation to your Submissions and/or Contributions; and")
            BulletPoint("warrant and represent that your Submissions and/or Contributions do not constitute confidential information.")
            Text("""
You are solely responsible for your Submissions and/or Contributions and you expressly agree to reimburse us for any and all losses that we may suffer because of your breach of (a) this section, (b) any third party’s intellectual property rights, or (c) applicable law.

**We may remove or edit your Content:** Although we have no obligation to monitor any Contributions, we shall have the right to remove or edit any Contributions at any time without notice if in our reasonable opinion we consider such Contributions harmful or in breach of these Legal Terms. If we remove or edit any such Contributions, we may also suspend or disable your account and report you to the authorities.
""")
            SectionTitle("Copyright Infringement")
            Text("We respect the intellectual property rights of others. If you believe that any material available on or through the Services infringes upon any copyright you own or control, please immediately refer to the \"COPYRIGHT INFRINGEMENTS\" section below.")
        }
    }
}
    
    
    struct UserRepresentationsSection: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("3. User Representations")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                Text("""
                By using the Services, you represent and warrant that: (1) all registration information you submit will be true, accurate, current, and complete; (2) you will maintain the accuracy of such information and promptly update such registration information as necessary; (3) you have the legal capacity and you agree to comply with these Legal Terms; (4) you are not a minor in the jurisdiction in which you reside, (5) you will not access the Services through automated or non-human means, whether through a bot, script, or otherwise; (6) you will not use the Services for any illegal or unauthorized purpose; and (7) your use of the Services will not violate any applicable law or regulation.

                If you provide any information that is untrue, inaccurate, not current, or incomplete, we have the right to suspend or terminate your account and refuse any and all current or future use of the Services (or any portion thereof).
                """)
                    .padding(.bottom, 10)
            }
        }
    }

    struct UserRegistrationSection: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("4. User Registration")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)


                Text("""
                You may be required to register with the Services. You agree to keep your password confidential and will be responsible for all use of your account and password. We reserve the right to remove, reclaim, or change a username you select if we determine, in our sole discretion, that such username is inappropriate, obscene, or otherwise objectionable.
                """)
                    .padding(.bottom, 10)
            }
        }
    }

    struct ProhibitedActivitiesSection: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("5. Prohibited Activities")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                Text("""
                You may not access or use the Services for any purpose other than that for which we make the Services available. The Services may not be used in connection with any commercial endeavors except those that are specifically endorsed or approved by us.

                As a user of the Services, you agree not to:

                  - Systematically retrieve data or other content from the Services to create or compile, directly or indirectly, a collection, compilation, database, or directory without written permission from us.
                  - Trick, defraud, or mislead us and other users, especially in any attempt to learn sensitive account information such as user passwords.
                  - Circumvent, disable, or otherwise interfere with security-related features of the Services, including features that prevent or restrict the use or copying of any Content or enforce limitations on the use of the Services and/or the Content contained therein.
                - Disparage, tarnish, or otherwise harm, in our opinion, us and/or the Services.
                - Use any information obtained from the Services in order to harass, abuse, or harm another person.
                - Make improper use of our support services or submit false reports of abuse or misconduct.
                - Use the Services in a manner inconsistent with any applicable laws or regulations.
                - Engage in unauthorized framing of or linking to the Services.
                - Upload or transmit (or attempt to upload or to transmit) viruses, Trojan horses, or other material, including excessive use of capital letters and spamming (continuous posting of repetitive text), that interferes with any party’s uninterrupted use and enjoyment of the Services or modifies, impairs, disrupts, alters, or interferes with the use, features, functions, operation, or maintenance of the Services.
                - Engage in any automated use of the system, such as using scripts to send comments or messages, or using any data mining, robots, or similar data gathering and extraction tools.
                - Delete the copyright notice or other proprietary rights notices from any Content.
                - Attempt to impersonate another user or person or use the username of another user.
                - Upload or transmit (or attempt to upload or to transmit) any material that acts as a passive or active information collection or transmission mechanism, including without limitation, clear graphics interchange formats ("gifs"), 1×1 pixels, web bugs, cookies, or other similar devices (sometimes referred to as "spyware" or "passive collection mechanisms" or "pcms").
                - Interfere with, disrupt, or create an undue burden on the Services or the networks or services connected to the Services.
                - Harass, annoy, intimidate, or threaten any of our employees or agents engaged in providing any portion of the Services to you.
                - Attempt to bypass any measures of the Services designed to prevent or restrict access to the Services, or any portion of the Services.
                - Copy or adapt the Services' software, including but not limited to Flash, PHP, HTML, JavaScript, or other code.
                - Except as permitted by applicable law, decipher, decompile, disassemble, or reverse engineer any of the software comprising or in any way making up a part of the Services.
                - Except as may be the result of standard search engine or Internet browser usage, use, launch, develop, or distribute any automated system, including without limitation, any spider, robot, cheat utility, scraper, or offline reader that accesses the Services, or use or launch any unauthorized script or other software.
                - Use a buying agent or purchasing agent to make purchases on the Services.
                - Make any unauthorized use of the Services, including collecting usernames and/or email addresses of users by electronic or other means for the purpose of sending unsolicited email, or creating user accounts by automated means or under false pretenses.
                - Use the Services as part of any effort to compete with us or otherwise use the Services and/or the Content for any revenue-generating endeavor or commercial enterprise.
                - Use the Services to advertise or offer to sell goods and services.
                - Sell or otherwise transfer your profile.
                """)
                    .padding(.bottom, 10)
            }
        }
    }

    struct UserGeneratedContributionsSection: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("6. User Generated Contributions")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                Text("""
                The Services may invite you to chat, contribute to, or participate in blogs, message boards, online forums, and other functionality, and may provide you with the opportunity to create, submit, post, display, transmit, perform, publish, distribute, or broadcast content and materials to us or on the Services, including but not limited to text, writings, video, audio, photographs, graphics, comments, suggestions, or personal information or other material (collectively, "Contributions"). Contributions may be viewable by other users of the Services and through third-party websites. As such, any Contributions you transmit may be treated as non-confidential and non-proprietary.

                When you create or make available any Contributions, you thereby represent and warrant that:

                - The creation, distribution, transmission, public display, or performance, and the accessing, downloading, or copying of your Contributions do not and will not infringe the proprietary rights, including but not limited to the copyright, patent, trademark, trade secret, or moral rights of any third party.
                - You are the creator and owner of or have the necessary licenses, rights, consents, releases, and permissions to use and to authorize us, the Services, and other users of the Services to use your Contributions in any manner contemplated by the Services and these Legal Terms.
                - You have the written consent, release, and/or permission of each and every identifiable individual person in your Contributions to use the name or likeness of each and every such identifiable individual person to enable inclusion and use of your Contributions in any manner contemplated by the Services and these Legal Terms.
                - Your Contributions are not false, inaccurate, or misleading.
                - Your Contributions are not unsolicited or unauthorized advertising, promotional materials, pyramid schemes, chain letters, spam, mass mailings, or other forms of solicitation.
                - Your Contributions are not obscene, lewd, lascivious, filthy, violent, harassing, libelous, slanderous, or otherwise objectionable (as determined by us).
                - Your Contributions do not ridicule, mock, disparage, intimidate, or abuse anyone.
                - Your Contributions are not used to harass or threaten (in the legal sense of those terms) any other person and to promote violence against a specific person or class of people.
                - Your Contributions do not violate any applicable law, regulation, or rule.
                - Your Contributions do not violate the privacy or publicity rights of any third party.
                - Your Contributions do not violate any applicable law concerning child pornography, or otherwise intended to protect the health or well-being of minors.
                - Your Contributions do not include any offensive comments that are connected to race, national origin, gender, sexual preference, or physical handicap.
                - Your Contributions do not otherwise violate, or link to material that violates, any provision of these Legal Terms, or any applicable law or regulation.
                
                Any use of the Services in violation of the foregoing violates these Legal Terms and may result in, among other things, termination or suspension of your rights to use the Services.
                """)
                    .padding(.bottom, 10)
            }
        }
    }

struct ContributionLicenseSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("7. Contribution License")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 8)

            Text("""
            By posting your Contributions to any part of the Services, you automatically grant, and you represent and warrant that you have the right to grant, to us an unrestricted, unlimited, irrevocable, perpetual, non-exclusive, transferable, royalty-free, fully-paid, worldwide right, and license to host, use, copy, reproduce, disclose, sell, resell, publish, broadcast, retitle, archive, store, cache, publicly perform, publicly display, reformat, translate, transmit, excerpt (in whole or in part), and distribute such Contributions (including, without limitation, your image and voice) for any purpose, commercial, advertising, or otherwise, and to prepare derivative works of, or incorporate into other works, such Contributions, and grant and authorize sublicenses of the foregoing. The use and distribution may occur in any media formats and through any media channels.

            This license will apply to any form, media, or technology now known or hereafter developed, and includes our use of your name, company name, and franchise name, as applicable, and any of the trademarks, service marks, trade names, logos, and personal and commercial images you provide. You waive all moral rights in your Contributions, and you warrant that moral rights have not otherwise been asserted in your Contributions.

            We do not assert any ownership over your Contributions. You retain full ownership of all of your Contributions and any intellectual property rights or other proprietary rights associated with your Contributions. We are not liable for any statements or representations in your Contributions provided by you in any area on the Services. You are solely responsible for your Contributions to the Services and you expressly agree to exonerate us from any and all responsibility and to refrain from any legal action against us regarding your Contributions.

            We have the right, in our sole and absolute discretion, (1) to edit, redact, or otherwise change any Contributions; (2) to re-categorize any Contributions to place them in more appropriate locations on the Services; and (3) to pre-screen or delete any Contributions at any time and for any reason, without notice. We have no obligation to monitor your Contributions.
            """)
                .padding(.vertical, 5)
        }
    }
}

struct MobileApplicationLicenseSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("8. Mobile Application License")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 8)

            Text("""
            **Use License**
            
            If you access the Services via the App, then we grant you a revocable, non-exclusive, non-transferable, limited right to install and use the App on wireless electronic devices owned or controlled by you, and to access and use the App on such devices strictly in accordance with the terms and conditions of this mobile application license contained in these Legal Terms. You shall not: (1) except as permitted by applicable law, decompile, reverse engineer, disassemble, attempt to derive the source code of, or decrypt the App; (2) make any modification, adaptation, improvement, enhancement, translation, or derivative work from the App; (3) violate any applicable laws, rules, or regulations in connection with your access or use of the App; (4) remove, alter, or obscure any proprietary notice (including any notice of copyright or trademark) posted by us or the licensors of the App; (5) use the App for any revenue-generating endeavor, commercial enterprise, or other purpose for which it is not designed or intended; (6) make the App available over a network or other environment permitting access or use by multiple devices or users at the same time; (7) use the App for creating a product, service, or software that is, directly or indirectly, competitive with or in any way a substitute for the App; (8) use the App to send automated queries to any website or to send any unsolicited commercial email; or (9) use any proprietary information or any of our interfaces or our other intellectual property in the design, development, manufacture, licensing, or distribution of any applications, accessories, or devices for use with the App.

            **Apple and Android Devices**
            
            The following terms apply when you use the App obtained from either the Apple Store or Google Play (each an "App Distributor") to access the Services: (1) the license granted to you for our App is limited to a non-transferable license to use the application on a device that utilizes the Apple iOS or Android operating systems, as applicable, and in accordance with the usage rules set forth in the applicable App Distributor’s terms of service; (2) we are responsible for providing any maintenance and support services with respect to the App as specified in the terms and conditions of this mobile application license contained in these Legal Terms or as otherwise required under applicable law, and you acknowledge that each App Distributor has no obligation whatsoever to furnish any maintenance and support services with respect to the App; (3) in the event of any failure of the App to conform to any applicable warranty, you may notify the applicable App Distributor, and the App Distributor, in accordance with its terms and policies, may refund the purchase price, if any, paid for the App, and to the maximum extent permitted by applicable law, the App Distributor will have no other warranty obligation whatsoever with respect to the App; (4) you represent and warrant that (i) you are not located in a country that is subject to a US government embargo, or that has been designated by the US government as a "terrorist supporting" country and (ii) you are not listed on any US government list of prohibited or restricted parties; (5) you must comply with applicable third-party terms of agreement when using the App, e.g., if you have a VoIP application, then you must not be in violation of their wireless data service agreement when using the App; and (6) you acknowledge and agree that the App Distributors are third-party beneficiaries of the terms and conditions in this mobile application license contained in these Legal Terms, and that each App Distributor will have the right (and will be deemed to have accepted the right) to enforce the terms and conditions in this mobile application license contained in these Legal Terms against you as a third-party beneficiary thereof.
            """)
                .padding(.vertical, 5)
        }
    }
}


struct ServicesManagementSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("9. Services Management")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 8)

            Text("""
            We reserve the right, but not the obligation, to: (1) monitor the Services for violations of these Legal Terms; (2) take appropriate legal action against anyone who, in our sole discretion, violates the law or these Legal Terms, including without limitation, reporting such user to law enforcement authorities; (3) in our sole discretion and without limitation, refuse, restrict access to, limit the availability of, or disable (to the extent technologically feasible) any of your Contributions or any portion thereof; (4) in our sole discretion and without limitation, notice, or liability, to remove from the Services or otherwise disable all files and content that are excessive in size or are in any way burdensome to our systems; and (5) otherwise manage the Services in a manner designed to protect our rights and property and to facilitate the proper functioning of the Services.
            """)
                .padding(.vertical, 5)
        }
    }
}

struct PrivacyPolicySection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("10. Privacy Policy")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 5)

            Text("""
            We care about data privacy and security. Please review our Privacy Policy. By using the Services, you agree to be bound by our Privacy Policy, which is incorporated into these Legal Terms. Please be advised the Services are hosted in the United States. If you access the Services from any other region of the world with laws or other requirements governing personal data collection, use, or disclosure that differ from applicable laws in the United States, then through your continued use of the Services, you are transferring your data to the United States, and you expressly consent to have your data transferred to and processed in the United States.
            """)
                .padding(.vertical, 5)
        }
    }
}

struct CopyrightInfringementsSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("11. Copyright Infringements")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 5)

            Text("""
            We respect the intellectual property rights of others. If you believe that any material available on or through the Services infringes upon any copyright you own or control, please immediately notify us using the contact information provided below (a "Notification"). A copy of your Notification will be sent to the person who posted or stored the material addressed in the Notification. Please be advised that pursuant to applicable law you may be held liable for damages if you make material misrepresentations in a Notification. Thus, if you are not sure that material located on or linked to by the Services infringes your copyright, you should consider first contacting an attorney.
            """)
                .padding(.vertical, 5)
        }
    }
}

struct TermAndTerminationSection: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("12. Term and Termination")
                .font(.title)
                .fontWeight(.bold)
                .padding(.vertical, 5)

            Text("""
            These Legal Terms shall remain in full force and effect while you use the Services. WITHOUT LIMITING ANY OTHER PROVISION OF THESE LEGAL TERMS, WE RESERVE THE RIGHT TO, IN OUR SOLE DISCRETION AND WITHOUT NOTICE OR LIABILITY, DENY ACCESS TO AND USE OF THE SERVICES (INCLUDING BLOCKING CERTAIN IP ADDRESSES), TO ANY PERSON FOR ANY REASON OR FOR NO REASON, INCLUDING WITHOUT LIMITATION FOR BREACH OF ANY REPRESENTATION, WARRANTY, OR COVENANT CONTAINED IN THESE LEGAL TERMS OR OF ANY APPLICABLE LAW OR REGULATION. WE MAY TERMINATE YOUR USE OR PARTICIPATION IN THE SERVICES OR DELETE YOUR ACCOUNT AND ANY CONTENT OR INFORMATION THAT YOU POSTED AT ANY TIME, WITHOUT WARNING, IN OUR SOLE DISCRETION.

            If we terminate or suspend your account for any reason, you are prohibited from registering and creating a new account under your name, a fake or borrowed name, or the name of any third party, even if you may be acting on behalf of the third party. In addition to terminating or suspending your account, we reserve the right to take appropriate legal action, including without limitation pursuing civil, criminal, and injunctive redress.
            """)
                .padding(.vertical, 5)
        }
    }
}



//    struct ContributionLicenseSection: View {
//        var body: some View {
//            VStack(alignment: .leading) {
//                Text("7. CONTRIBUTION LICENSE")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .padding(.vertical, 5)
//
//                Text("""
//                By posting your Contributions to any part of the Services, you automatically grant, and you represent

    
    struct TermsOfUseView_Previews: PreviewProvider {
        static var previews: some View {
            TermsOfUseView()
        }
    }


